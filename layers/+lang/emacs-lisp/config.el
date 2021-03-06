;;; config.el --- Emacs Lisp Layer configuration File for Spacemacs
;;
<<<<<<< HEAD
;; Copyright (c) 2012-2016 Sylvain Benner & Contributors
=======
;; Copyright (c) 2012-2017 Sylvain Benner & Contributors
>>>>>>> upstream/master
;;
;; Author: Sylvain Benner <sylvain.benner@gmail.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;; Variables

(spacemacs|defvar-company-backends emacs-lisp-mode)
(spacemacs|defvar-company-backends ielm-mode)

(spacemacs|define-jump-handlers emacs-lisp-mode)
(spacemacs|define-jump-handlers lisp-interaction-mode)
