;;; org-shoplist-test.el --- Tests for org-shoplist
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

;;; org-shoplist-test.el ends here
