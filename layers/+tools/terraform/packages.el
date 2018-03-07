;;; packages.el --- terraform Layer packages File for Spacemacs
;;
<<<<<<< HEAD:layers/+config-files/terraform/packages.el
;; Copyright (c) 2012-2016 Sylvain Benner & Contributors
=======
;; Copyright (c) 2012-2017 Sylvain Benner & Contributors
>>>>>>> upstream/master:layers/+tools/terraform/packages.el
;;
;; Author: Brian Hicks <brian@brianthicks.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

(setq terraform-packages '(terraform-mode))

(defun terraform/init-terraform-mode ()
  (use-package terraform-mode
    :defer t))
