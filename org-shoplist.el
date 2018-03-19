;;; org-shoplist.el --- Eat the world

;; Copyright (C) 2017 Free Software Foundation, Inc.

;; Author: lordnik22
;; Version: 1.0.0
;; Keywords: org-mode, shopping-list, eating-plan, recipe-list
;; URL: https://github.com/lordnik22

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;; Commentary:
;; There is nothing done, yet.
;;; Code:
(require 'calc-ext)

(defconst org-shoplist-ing-re "(\\([1-9][0-9]*\\)\\(.*\\) \\(.+\\))"
  "Match any ingredient.
group 1: number
group 2: unit
group 3: ingredient-name")

(defun org-shoplist-ing-create (amount name)
  "Create an ingredient.
`AMOUNT' can be a string, a number or a valid sequence.
`NAME' is a string.
If one constraint gets disregarded throw error."
  (when (not (stringp name)) (error "Invalid name for ingredient"))
  (when (eq amount nil) (setq amount "0"))
  (when (numberp amount) (setq amount (number-to-string amount)))
  (save-match-data
    (if (and (stringp amount) (string-match "^[0-9]" amount))
	(list name (math-read-expr amount))
      (if (and (sequencep amount) (eq (car amount) (intern "*")) (sequencep (cdr amount)))
	  (list name amount)
	(error "Invalid amount for ingredient")))))

(defun org-shoplist-ing-name (ing)
  "Get name of `ING'."
  (car ing))

(defun org-shoplist-ing-amount (ing)
  "Get amount of `ING'."
  (car (cdr ing)))

(defun org-shoplist-ing-unit (ing)
  "Get unit of `ING'."
  (let ((amnt (org-shoplist-ing-amount ing)))
    (if (numberp amnt)
	nil
      (elt (elt amnt 2) 1))))

;;(require 'calc-ext)  (math-read-expr "100g")(* 100 (var g var-g))
;;calc-aent
;;(math-evaluate-expr (math-read-expr "100g+100g"))

(defun org-shoplist-recipe-create (name &rest ings)
  "Create a recipe.
`NAME' must be a string.
`INGS' must be vallid ingredients.
Use `org-shoplist-ing-create' to create valid ingredients."
  (when (eq name nil) (error "Invalid name for recipe"))
  (cons name ings))

(defun org-shoplist-recipe-name (recipe)
  "Get name of `RECIPE'."
  (car recipe))

(defun org-shoplist-recipe-first-ing (recipe)
  "Get first ingredient of `RECIPE'."
  (car (cdr recipe)))

(defun org-shoplist-recipe-get-all-ing (recipe)
  "Get all ingredients of `RECIPE'."
  (cdr recipe))

(defun org-shoplist-recipe-get-N-ing (recipe n)
  "Get from `RECIPE' the `N'th ingredient.
First = `n' = 1"
  (elt recipe n))

(defun org-shoplist-recipe-read ()
  "Assums that at start of recipe.
Return a recipe structure.
See `org-shoplist-recipe-create' for more details."
  (save-match-data
    (let ((recipe-name (progn
			 (search-forward-regexp org-heading-regexp nil t 1)
			 (match-string 2)))
	  (ing (when (search-forward-regexp (org-item-re) nil t 1)
		 (progn
		   (search-forward-regexp org-shoplist-ing-re nil t 1)
		   (org-shoplist-ing-create (concat (match-string 1) (match-string 2)) (match-string 3))))))
      (when (eq recipe-name nil) (error "Can't find a recipe"))
      ;; (looking-at org-list-end-re)
      (if (eq ing nil)
	  (org-shoplist-recipe-create recipe-name)
	(org-shoplist-recipe-create recipe-name ing)))))

(provide 'org-shoplist)
;;; org-shoplist.el ends here
