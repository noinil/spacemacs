;;; core-spacemacs.el --- Spacemacs Core File
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
(setq message-log-max 16384)
(defconst emacs-start-time (current-time))

(require 'subr-x nil 'noerror)
(require 'core-emacs-backports)
(require 'page-break-lines)
(require 'core-debug)
(require 'core-command-line)
(require 'core-dotspacemacs)
(require 'core-release-management)
(require 'core-auto-completion)
(require 'core-jump)
(require 'core-display-init)
(require 'core-themes-support)
(require 'core-fonts-support)
(require 'core-spacemacs-buffer)
(require 'core-keybindings)
(require 'core-toggle)
(require 'core-funcs)
(require 'core-micro-state)
(require 'core-transient-state)
(require 'core-use-package-ext)

(defgroup spacemacs nil
  "Spacemacs customizations."
  :group 'starter-kit
  :prefix 'spacemacs-)

;; loading progress bar variables
(defvar spacemacs-loading-char ?█)
(defvar spacemacs-loading-string "")
(defvar spacemacs-loading-counter 0)
(defvar spacemacs-loading-value 0)
;; (defvar spacemacs-loading-text "Loading")
;; (defvar spacemacs-loading-done-text "Ready!")
(defvar spacemacs-loading-dots-chunk-count 3)
(defvar spacemacs-loading-dots-count (window-total-size nil 'width))
(defvar spacemacs-loading-dots-chunk-size
  (/ spacemacs-loading-dots-count spacemacs-loading-dots-chunk-count))
(defvar spacemacs-loading-dots-chunk-threshold 0)

(defvar spacemacs-post-user-config-hook nil
  "Hook run after dotspacemacs/user-config")
(defvar spacemacs-post-user-config-hook-run nil
  "Whether `spacemacs-post-user-config-hook' has been run")

(defvar spacemacs--default-mode-line mode-line-format
  "Backup of default mode line format.")
(defvar spacemacs-initialized nil
  "Whether or not spacemacs has finished initializing by completing
the final step of executing code in `emacs-startup-hook'.")

(defun spacemacs/init ()
  "Perform startup initialization."
  (when spacemacs-debugp (spacemacs/init-debug))
  ;; silence ad-handle-definition about advised functions getting redefined
  (setq ad-redefinition-action 'accept)
  ;; this is for a smoother UX at startup (i.e. less graphical glitches)
  (hidden-mode-line-mode)
  (spacemacs//removes-gui-elements)
  (spacemacs//setup-ido-vertical-mode)
  ;; explicitly set the prefered coding systems to avoid annoying prompt
  ;; from emacs (especially on Microsoft Windows)
  (prefer-coding-system 'utf-8)
  ;; TODO move these variables when evil is removed from the bootstrapped
  ;; packages.
  (setq-default evil-want-C-u-scroll t
                ;; `evil-want-C-i-jump' is set to nil to avoid `TAB' being
                ;; overlapped in terminal mode. The GUI specific `<C-i>' is used
<<<<<<< HEAD
                ;; instead (defined in the init of `evil-jumper' package).
=======
                ;; instead.
>>>>>>> upstream/master
                evil-want-C-i-jump nil)
  (dotspacemacs/load-file)
  (require 'core-configuration-layer)
  (dotspacemacs|call-func dotspacemacs/init "Calling dotfile init...")
  (when dotspacemacs-maximized-at-startup
    (unless (frame-parameter nil 'fullscreen)
      (toggle-frame-maximized))
    (add-to-list 'default-frame-alist '(fullscreen . maximized)))
  (dotspacemacs|call-func dotspacemacs/user-init "Calling dotfile user init...")
  (setq dotspacemacs-editing-style (dotspacemacs//read-editing-style-config
                                    dotspacemacs-editing-style))
  (configuration-layer/initialize)
  ;; Apply theme
  (let ((default-theme (car dotspacemacs-themes)))
    (condition-case err
        (spacemacs/load-theme default-theme nil)
      ('error
       ;; fallback on Spacemacs default theme
       (setq spacemacs--default-user-theme default-theme)
       (setq dotspacemacs-themes (delq spacemacs--fallback-theme
                                       dotspacemacs-themes))
       (add-to-list 'dotspacemacs-themes spacemacs--fallback-theme)
       (setq default-theme spacemacs--fallback-theme)
       (load-theme spacemacs--fallback-theme t)))
    ;; protect used themes from deletion as orphans
    (setq configuration-layer--protected-packages
          (append
           (delq nil (mapcar 'spacemacs//get-theme-package
                             dotspacemacs-themes))
           configuration-layer--protected-packages))
    (setq-default spacemacs--cur-theme default-theme)
    (setq-default spacemacs--cycle-themes (cdr dotspacemacs-themes)))
  ;; font
  (spacemacs|do-after-display-system-init
   ;; If you are thinking to remove this call to `message', think twice. You'll
   ;; break the life of several Spacemacser using Emacs in daemon mode. Without
   ;; this, their chosen font will not be set on the *first* instance of
   ;; emacsclient, at least if different than their system font. You don't
   ;; believe me? Go ahead, try it. After you'll have notice that this was true,
   ;; increase the counter bellow so next people will give it more confidence.
   ;; Counter = 1
   (message "Setting the font...")
   (unless (spacemacs/set-default-font dotspacemacs-default-font)
     (spacemacs-buffer/warning
      "Cannot find any of the specified fonts (%s)! Font settings may not be correct."
      (if (listp (car dotspacemacs-default-font))
          (mapconcat 'car dotspacemacs-default-font ", ")
        (car dotspacemacs-default-font)))))
  ;; spacemacs init
  (setq inhibit-startup-screen t)
  (spacemacs-buffer/goto-buffer)
  (unless (display-graphic-p)
    ;; explicitly recreate the home buffer for the first GUI client
    ;; in order to correctly display the logo
    (spacemacs|do-after-display-system-init
     (kill-buffer (get-buffer spacemacs-buffer-name))
     (spacemacs-buffer/goto-buffer)))
  ;; This is set to nil during startup to allow Spacemacs to show buffers opened
  ;; as command line arguments.
  (setq initial-buffer-choice nil)
  (setq inhibit-startup-screen t)
<<<<<<< HEAD
  ;; bootstrap packages
  (spacemacs/load-or-install-protected-package 'evil t)
  (spacemacs/load-or-install-protected-package 'bind-map t)
  ;; bind-key is required by use-package
  (spacemacs/load-or-install-protected-package 'bind-key t)
  (spacemacs/load-or-install-protected-package 'which-key t)
  (spacemacs/load-or-install-protected-package 'use-package t)
  (setq use-package-verbose init-file-debug)
  ;; package-build is required by quelpa
  (spacemacs/load-or-install-protected-package 'package-build t)
  (setq quelpa-verbose init-file-debug
        quelpa-dir (concat spacemacs-cache-directory "quelpa/")
        quelpa-build-dir (expand-file-name "build" quelpa-dir)
        quelpa-persistent-cache-file (expand-file-name "cache" quelpa-dir)
        quelpa-update-melpa-p nil)
  (spacemacs/load-or-install-protected-package 'quelpa t)
  ;; inject use-package hooks for easy customization of stock package
  ;; configuration
  (setq use-package-inject-hooks t)
=======
>>>>>>> upstream/master
  (require 'core-keybindings)
  ;; for convenience and user support
  (unless (fboundp 'tool-bar-mode)
    (spacemacs-buffer/message (concat "No graphical support detected, "
                                      "you won't be able to launch a "
                                      "graphical instance of Emacs"
                                      "with this build.")))
  ;; check for new version
  (if dotspacemacs-mode-line-unicode-symbols
      (setq-default spacemacs-version-check-lighter "[⇪]"))
  ;; install the dotfile if required
  (dotspacemacs/maybe-install-dotfile)
  ;; install user default theme if required
  (when spacemacs--default-user-theme
    (spacemacs/load-theme spacemacs--default-user-theme 'install)))

(defun spacemacs//removes-gui-elements ()
  "Remove the menu bar, tool bar and scroll bars."
  ;; removes the GUI elements
  (when (and (fboundp 'tool-bar-mode) (not (eq tool-bar-mode -1)))
    (tool-bar-mode -1))
  (unless (spacemacs/window-system-is-mac)
    (when (and (fboundp 'menu-bar-mode) (not (eq menu-bar-mode -1)))
      (menu-bar-mode -1)))
  (when (and (fboundp 'scroll-bar-mode) (not (eq scroll-bar-mode -1)))
    (scroll-bar-mode -1))
  ;; tooltips in echo-aera
  (when (and (fboundp 'tooltip-mode) (not (eq tooltip-mode -1)))
    (tooltip-mode -1)))

(defun spacemacs//setup-ido-vertical-mode ()
  "Setup `ido-vertical-mode'."
  (require 'ido-vertical-mode)
  (ido-vertical-mode t)
  (add-hook
   'ido-setup-hook
   ;; think about hacking directly `ido-vertical-mode' source in libs instead.
   (defun spacemacs//ido-vertical-natural-navigation ()
     ;; more natural navigation keys: up, down to change current item
     ;; left to go up dir
     ;; right to open the selected item
     (define-key ido-completion-map (kbd "<up>") 'ido-prev-match)
     (define-key ido-completion-map (kbd "<down>") 'ido-next-match)
     (define-key ido-completion-map (kbd "<left>") 'ido-delete-backward-updir)
     (define-key ido-completion-map (kbd "<right>") 'ido-exit-minibuffer))))

(defun display-startup-echo-area-message ()
  "Change the default welcome message of minibuffer to another one."
  (message "Spacemacs is ready."))

(defun spacemacs/defer-until-after-user-config (func)
  "Call FUNC if dotspacemacs/user-config has been called. Otherwise,
defer call using `spacemacs-post-user-config-hook'."
  (if spacemacs-post-user-config-hook-run
      (funcall func)
    (add-hook 'spacemacs-post-user-config-hook func)))

(defun spacemacs/setup-startup-hook ()
  "Add post init processing."
  (add-hook
   'emacs-startup-hook
   (defun spacemacs/startup-hook ()
     ;; This is set here so that emacsclient will show the startup buffer (and
     ;; so that it can be changed in user-config if necessary). It was set to
     ;; nil earlier in the startup process to properly handle command line
     ;; arguments.
     (setq initial-buffer-choice (lambda () (get-buffer spacemacs-buffer-name)))
     ;; Ultimate configuration decisions are given to the user who can defined
     ;; them in his/her ~/.spacemacs file
<<<<<<< HEAD
     ;; TODO remove support for dotspacemacs/config in 0.106
     (if (fboundp 'dotspacemacs/user-config)
         (dotspacemacs|call-func dotspacemacs/user-config
                                 "Calling dotfile user config...")
       (spacemacs-buffer/warning (concat "`dotspacemacs/config' is deprecated, "
                                         "please rename your function to "
                                         "`dotspacemacs/user-config'"))
       (dotspacemacs|call-func dotspacemacs/config
                               "Calling dotfile user config..."))
     (when (fboundp dotspacemacs-scratch-mode)
       (with-current-buffer "*scratch*"
         (funcall dotspacemacs-scratch-mode)))
     ;; from jwiegley
     ;; https://github.com/jwiegley/dot-emacs/blob/master/init.el
     (let ((elapsed (float-time
                     (time-subtract (current-time) emacs-start-time))))
       (spacemacs-buffer/append
        (format "\n[%s packages loaded in %.3fs]\n"
                (configuration-layer/configured-packages-count)
                elapsed)))
     (spacemacs/check-for-new-version spacemacs-version-check-interval))))

(defun spacemacs//describe-system-info-string ()
  "Gathers info about your Spacemacs setup and returns it as a string."
  (format
   (concat "#### System Info\n"
           "- OS: %s\n"
           "- Emacs: %s\n"
           "- Spacemacs: %s\n"
           "- Spacemacs branch: %s (rev. %s)\n"
           "- Graphic display: %s\n"
           "- Distribution: %s\n"
           "- Editing style: %s\n"
           "- Completion: %s\n"
           "- Layers:\n```elisp\n%s```\n")
   system-type
   emacs-version
   spacemacs-version
   (spacemacs/git-get-current-branch)
   (spacemacs/git-get-current-branch-rev)
   (display-graphic-p)
   dotspacemacs-distribution
   dotspacemacs-editing-style
   (cond ((configuration-layer/layer-usedp 'spacemacs-helm)
          'helm)
         ((configuration-layer/layer-usedp 'spacemacs-ivy)
          'ivy)
         (t 'helm))
   (pp-to-string dotspacemacs-configuration-layers)))

(defun spacemacs/describe-system-info ()
  "Gathers info about your Spacemacs setup and copies to clipboard."
  (interactive)
  (let ((sysinfo (spacemacs//describe-system-info-string)))
    (kill-new sysinfo)
    (message sysinfo)
    (message (concat "Information has been copied to clipboard.\n"
                     "You can paste it in the gitter chat.\n"
                     "Check the *Messages* buffer if you need to review it"))))
=======
     (dotspacemacs|call-func dotspacemacs/user-config
                             "Calling dotfile user config...")
     (run-hooks 'spacemacs-post-user-config-hook)
     (setq spacemacs-post-user-config-hook-run t)
     (when (fboundp dotspacemacs-scratch-mode)
       (with-current-buffer "*scratch*"
         (funcall dotspacemacs-scratch-mode)))
     (configuration-layer/display-summary emacs-start-time)
     (spacemacs-buffer//startup-hook)
     (spacemacs/check-for-new-version nil spacemacs-version-check-interval)
     (setq spacemacs-initialized t))))
>>>>>>> upstream/master

(defun spacemacs//describe-last-keys-string ()
  "Gathers info about your Emacs last keys and returns it as a string."
  (view-lossage)
  (let* ((lossage-buffer "*Help*")
         (last-keys (format "#### Emacs last keys\n```text\n%s```\n"
                            (with-current-buffer lossage-buffer
                              (buffer-string)))))
    (kill-buffer lossage-buffer)
    last-keys))

(defun spacemacs/describe-last-keys ()
  "Gathers info about your Emacs last keys and copies to clipboard."
  (interactive)
  (let ((lossage (spacemacs//describe-last-keys-string)))
    (kill-new lossage)
    (message lossage)
    (message (concat "Information has been copied to clipboard.\n"
                     (propertize
                      "PLEASE REVIEW THE DATA BEFORE GOING FURTHER AS IT CAN CONTAIN SENSITIVE DATA (PASSWORD, ...)\n"
                      'face 'font-lock-warning-face)
                     "You can paste it in the gitter chat.\n"
                     "Check the *Messages* buffer if you need to review it"))))

(defun spacemacs/report-issue (arg)
  "Browse the page for creating a new Spacemacs issue on GitHub,
with the message pre-filled with template and information."
  (interactive "P")
  (let* ((url "http://github.com/syl20bnr/spacemacs/issues/new?body=")
         (template (with-temp-buffer
                     (insert-file-contents-literally
                      (concat configuration-layer-template-directory "REPORTING.template"))
                     (buffer-string))))
    ;; Include the system info description directly into the template
    (setq template (replace-regexp-in-string
                    "%SYSTEM_INFO%"
                    (spacemacs//describe-system-info-string)
                    template [keep-case]))
    ;; Include the backtrace directly in the template, if it exists
    (setq template (replace-regexp-in-string
                    "%BACKTRACE%"
                    (if (get-buffer "*Backtrace*")
                        (with-current-buffer "*Backtrace*"
                           (buffer-substring-no-properties
                            (point-min) (min (point-max) 1000)))
                      "BACKTRACE IF RELEVANT")
                    template [keep-case]))
    ;; Include the last keys description directly into the template, if
    ;; prefix argument has been passed
    (setq template (replace-regexp-in-string
                    "(%LAST_KEYS%)\n"
                    (if (and arg (y-or-n-p (concat "Do you really want to "
                                                   "include your last pressed keys? It "
                                                   "may include some sensitive data.")))
                        (concat (spacemacs//describe-last-keys-string) "\n")
                      "")
                    template [keep-case]))
    ;; Create the encoded url
    (setq url (url-encode-url (concat url template)))
    ;; HACK: Needed because the first `#' is not encoded
    (setq url (replace-regexp-in-string "#" "%23" url))
    (browse-url url)))

(provide 'core-spacemacs)
