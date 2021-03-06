;;; core-configuration-layer-ftest.el --- Spacemacs Functional Test File
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
(require 'core-configuration-layer)

;; ---------------------------------------------------------------------------
;; configuration-layer//declare-used-layers
;; ---------------------------------------------------------------------------

(ert-deftest test-declare-layers--bootstrap-layer-always-first ()
  (let ((dotspacemacs-distribution 'spacemacs)
        (dotspacemacs-configuration-layers '(emacs-lisp
                                             (git :variables foo 'bar)))
        configuration-layer--used-layers
        (configuration-layer--indexed-layers (make-hash-table :size 1024)))
    (configuration-layer/discover-layers)
    (configuration-layer//declare-used-layers dotspacemacs-configuration-layers)
    (should (eq 'spacemacs-bootstrap
                (first configuration-layer--used-layers)))))

(ert-deftest test-declare-layers--distribution-layer-is-second ()
  (let ((dotspacemacs-distribution 'spacemacs-base)
        (dotspacemacs-configuration-layers '(emacs-lisp
                                             (git :variables foo 'bar)))
        configuration-layer--used-layers
        (configuration-layer--indexed-layers (make-hash-table :size 1024)))
    (configuration-layer/discover-layers)
    (configuration-layer//declare-used-layers dotspacemacs-configuration-layers)
    (should (eq 'spacemacs-base (second configuration-layer--used-layers)))))

;; ---------------------------------------------------------------------------
;; Lazy installation of layers
;; ---------------------------------------------------------------------------
