;;; org-shoplist-test.el --- Tests for org-shoplist
;;; Commentary:
;; Tests the data structures and functions of org-shoplist
;;; Code:
(setq org-shoplist-ingredient-units '("g" "ml"))
(setq org-shoplist-ingredient-regex
  (concat "(\\([1-9][0-9]*\\)"
	  "\\("
	  (mapconcat 'identity
		     org-shoplist-ingredient-units
		     "\\|")
	  "\\)?"
	  " \\(.+?\\))")) 

(ert-deftest org-shoplist-test/feeling-better? ()
    "Checks if it's a good day to program."
  (should (= 1 1)))

(ert-deftest org-shoplist-test/str-to-ing-empty-str ()
  (should (equal nil (org-shoplist-str-to-ing ""))))

(ert-deftest org-shoplist-test/str-to-ing-no-ing-in-str ()
  (should (equal nil (org-shoplist-str-to-ing "foo"))))

(ert-deftest org-shoplist-test/str-to-ing-empty-ing-in-str ()
  (should (equal nil (org-shoplist-str-to-ing "()"))))

(ert-deftest org-shoplist-test/str-to-ing-one-ing-in-str ()
  (should (equal '((100 nil "Nuts")) (org-shoplist-str-to-ing "(100 Nuts)"))))

(ert-deftest org-shoplist-test/str-to-ing-ing-surrounded-with-verb-and-adj ()
  (should (equal '((100 nil "Nuts")) (org-shoplist-str-to-ing "crush (100 Nuts) massively"))))

(ert-deftest org-shoplist-test/str-to-ing-with-measure ()
  (should (equal '((100 "g" "Nuts")) (org-shoplist-str-to-ing "(100g Nuts)"))))

(ert-deftest org-shoplist-test/str-to-ing-with-adj-in-ing ()
  (should (equal '((100 "g" "crushed Nuts")) (org-shoplist-str-to-ing "(100g crushed Nuts)"))))

(ert-deftest org-shoplist-test/str-to-ing-empty-ing+ing-in-one-string ()
  "One mepty ing and a normal ing in one string."
  (should (equal '((100 "g" "Nuts")) (org-shoplist-str-to-ing "()(100g Nuts)"))))

(ert-deftest org-shoplist-test/str-to-ing-two-ings-in-one-string ()
  (should (equal '((100 "ml" "Milk")
		   (100 "g" "Nuts")) (org-shoplist-str-to-ing "(100ml Milk)(100g Nuts)"))))

(ert-deftest org-shoplist-test/str-to-ing-three-ings-in-one-string ()
  (should (equal '((100 "ml" "Milk")
		   (100 "g" "Nuts")
		   (1 nil "Lemon")) (org-shoplist-str-to-ing "(100ml Milk)(100g Nuts)(1 Lemon)"))))

(ert-deftest org-shoplist-test/str-to-ing-two-ings-in-sentence ()
  (should (equal '((100 "ml" "Milk")
		   (100 "g" "Nuts")) (org-shoplist-str-to-ing "mix (100ml Milk) and (100g Nuts) toghter"))))

(ert-deftest org-shoplist-test/str-to-ing-nested-parenthese-one-ing ()
  (should (equal '((100 "ml" "Milk")) (org-shoplist-str-to-ing "((100ml Milk))"))))

(ert-deftest org-shoplist-test/str-to-ing-nested-parenthese-two-ing ()
  (should (equal '((100 "ml" "Milk")
		   (100 "g" "Nuts")) (org-shoplist-str-to-ing "((100ml Milk)(100g Nuts))"))))

;;; org-shoplist-test.el ends here
