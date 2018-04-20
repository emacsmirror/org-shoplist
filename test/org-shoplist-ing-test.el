;;; org-shoplist-ing-test.el --- Tests for org-shoplist
;;; Commentary:
;; Tests the data structures and functions of org-shoplist
;;; Code:
(ert-deftest org-shoplist-test/feeling-better? ()
    "Checks if it's a good day to program."
  (should (= 1 1)))


(ert-deftest org-shoplist-test/ing-create-nil-nil ()
  (should (equal '(error "Invalid ‘NAME’ for ingredient")
		 (should-error (org-shoplist-ing-create nil nil)))))

(ert-deftest org-shoplist-test/ing-create-normal ()
  (should (equal '("Nuts" (* 100 (var g var-g))) (org-shoplist-ing-create "100g" "Nuts"))))

(ert-deftest org-shoplist-test/ing-create-when-amount-nil ()
  (should (equal '("Nuts" 0) (org-shoplist-ing-create nil "Nuts"))))

(ert-deftest org-shoplist-test/ing-create-when-amount-invalid-number ()
  (should (equal '(error "Invalid ‘AMOUNT’ for ingredient")
		 (should-error (org-shoplist-ing-create "asdf" "Nuts")))))

(ert-deftest org-shoplist-test/ing-create-when-amount-true-number ()
  (should (equal '("Nuts" 100) (org-shoplist-ing-create 100 "Nuts"))))

(ert-deftest org-shoplist-test/ing-create-when-name-nil ()
  (should (equal '(error "Invalid ‘NAME’ for ingredient")
		 (should-error (org-shoplist-ing-create "100g" nil)))))

(ert-deftest org-shoplist-test/ing-create-when-custom-unit ()
  (should (equal '("Nuts" (* 100 (var foo var-foo))) (org-shoplist-ing-create "100foo" "Nuts"))))

(ert-deftest org-shoplist-test/ing-create-when-unit-nil ()
  (should (equal '("Nuts" 100) (org-shoplist-ing-create 100 "Nuts"))))

(ert-deftest org-shoplist-test/ing-create-amount-simple-sequence ()
  (should (equal '("Nuts" (* 100 (var g var-g))) (org-shoplist-ing-create '(* 100 (var g var-g)) "Nuts"))))

(ert-deftest org-shoplist-test/ing-unit-amount-simple-sequence ()
  (should (eq 'g (org-shoplist-ing-unit (org-shoplist-ing-create "100g" "Nuts")))))

(ert-deftest org-shoplist-test/ing-unit-amount-number ()
  (should (eq nil (org-shoplist-ing-unit (org-shoplist-ing-create 100 "Nuts")))))

(ert-deftest org-shoplist-test/ing-unit-dont-change-match-data ()
  "Match data shouldn't be changed by call."
  (let ((data-before (match-data))
	(data-after nil))
    (org-shoplist-ing-create "100g" "Nuts")
    (setq data-after (match-data))
    (should (equal data-before data-after))))

(ert-deftest org-shoplist-test/ing-read-str-nil ()
  "Return nil when nil is passed as `STR'."
  (should (eq nil (org-shoplist-ing-read nil))))

(ert-deftest org-shoplist-test/ing-read-empty-str ()
  "Return nil when empty string is passed."
  (should (eq nil (org-shoplist-ing-read ""))))

(ert-deftest org-shoplist-test/ing-read-str-only-ing ()
  "Return one ingredient-structure when str contains only a ing."
  (should (equal '(("Nuts" (* 100 (var g var-g)))) (org-shoplist-ing-read "(100g Nuts)"))))

(ert-deftest org-shoplist-test/ing-read-str-only-trash ()
  "Return nil when str is not empty-string but contains only trash."
  (should (equal nil (org-shoplist-ing-read "This is trash"))))

(ert-deftest org-shoplist-test/ing-read-str-trash-with-one-ing ()
  "Return one ingredient-structure when str contains one ingredient"
  (should (equal '(("Nuts" (* 100 (var g var-g)))) (org-shoplist-ing-read "This (100g Nuts) is trash"))))

(ert-deftest org-shoplist-test/ing-read-str-two-ings ()
  "Return a list with two ingredient-structures when str contains two ingredient"
  (should (equal '(("Nuts" (* 100 (var g var-g))) ("Milk" (* 100 (var ml var-ml)))) (org-shoplist-ing-read "(100g Nuts)(100ml Milk)"))))

(ert-deftest org-shoplist-test/ing-read-str-two-ings-with-trash ()
  "Return a list with two ingredient-structures when str contains two ingredient"
  (should (equal '(("Nuts" (* 100 (var g var-g))) ("Milk" (* 100 (var ml var-ml))))
		 (org-shoplist-ing-read "This is (100g Nuts) much (100ml Milk) trash."))))

(ert-deftest org-shoplist-test/ing-read-str-three-ings ()
  "Return a list with three ingredient-structures when str contains thee ingredient"
  (should (equal '(("Nuts" (* 100 (var g var-g)))
		   ("Milk" (* 100 (var ml var-ml)))
		   ("Flour" (* 100 (var kg var-kg))))
		 (org-shoplist-ing-read "(100g Nuts)(100ml Milk)(100kg Flour)"))))

(ert-deftest org-shoplist-test/ing-read-str-four-ings ()
  "Return a list with four ingredient-structures when str contains four ingredient"
  (should (equal '(("Nuts" (* 100 (var g var-g)))
		   ("Milk" (* 100 (var ml var-ml)))
		   ("Flour" (* 100 (var kg var-kg)))
		   ("Egg" 1))
		 (org-shoplist-ing-read "(100g Nuts)(100ml Milk)(100kg Flour)(1 Egg)"))))

(ert-deftest org-shoplist-test/ing-read-no-pars-read-at-point ()
  "Parse line where point is at when no parameters passed"
  (org-shoplist-test-test-in-buffer
   (lambda ()
     (insert "(100g Nuts)")
     (should (equal '(("Nuts" (* 100 (var g var-g))))
		    (org-shoplist-ing-read))))))

(ert-deftest org-shoplist-test/ing-read-when-previous-search-no-ings ()
  "Parse line where point is at when no parameters passed"
  (org-shoplist-test-test-in-buffer
   (lambda ()
     (insert "Nuts")
     (goto-char (point-min))
     (search-forward-regexp "s" nil t 1)
     (should (eq nil
		 (org-shoplist-ing-read))))))

(ert-deftest org-shoplist-test/ing-read-when-previous-search-with-ings ()
  "Parse line where point is at when no parameters passed"
  (org-shoplist-test-test-in-buffer
   (lambda ()
     (insert "(100g Nuts)")
     (goto-char (point-min))
     (search-forward-regexp "s" nil t 1)
     (should (equal '(("Nuts" (* 100 (var g var-g))))
		    (org-shoplist-ing-read))))))
;;; org-shoplist-ing-test.el ends here
