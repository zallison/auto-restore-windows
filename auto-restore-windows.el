;; auto-restore-windows.el -- automatially restore window
;; configuration when changing into target buffers
;;
;;
;; Copyright (C)
;;    2016 Zack Allison
;; Author: Zack Allison <zack@zackallison.com>
;; Version: 0.1.0
;; License: GPL (see LICENSE)
;;
;; Commentary:
;;
;; Load the package and bind the commands
;; "auto-restore-windows-save-window" and
;; "auto-restore-windows-clear-window" to something convenient,
;;
;; Executing auto-restore-windows-save-window will store the current
;; window configuration and will restore the configuration when
;; switching back to the buffer.
;;
;; Executing auto-restore-windows-clear-window will clear the
;; configuration for the buffer.
;;
;; With the prefix operator (C-u) it will apply the settings to every
;; buffer in the frame instead of just the current buffer.
;;
;; The variable "auto-restore-windows-show-messages" controls whether
;; or not to echo message in the minibuffer.  This setting and the
;; strings to be displayed can be edited by customizing the
;; "auto-restore-windows" group.
;;
;; Usage:
;; ;; Load the package and set the keybindings you want
;; ;; I like to stick them in with the "purpose-mode" keys, as dedication
;; ;; is part of the windows config that is copied and restored!
;;
;; ;; If using use-package, something like
;; (use-package auto-restore-windows
;;  :config
;;  ;; C-c , C
;;  (bind-key "C" 'auto-restore-windows-clear-window purpose-mode-prefix-map) ;; I like these bindings, YMMV
;;  ;; C-c , S
;;  (bind-key "S" 'auto-restore-windows-save-window  purpose-mode-prefix-map))
;;
;; ;; Otherwise just require it and set your keybindings
;; (require 'auto-restore-windows)
;; (define-key purpose-mode-prefix-map "C" 'auto-restore-windows-clear-window)
;; (define-key purpose-mode-prefix-map "S" 'auto-restore-windows-save-window)
;;
;; Code:

(defcustom auto-restore-windows-show-messages t
  "If non-nil auto-restore-windows will display messages when
saving, clearing, or restoring windows"
  :type 'boolean
  :group 'auto-restore-windows )

(defcustom auto-restore-windows-message-saved "window config saved"
  "The string to display when 'auto-restore-windows-show-messages is t"
  :type 'string
  :group 'auto-restore-windows)

(defcustom auto-restore-windows-message-cleared "window config cleared"
  "The string to display when 'auto-restore-windows-show-messages is t"
  :type 'string
  :group 'auto-restore-windows)

(defcustom auto-restore-windows-message-all-buffers "in all buffers"
  "The string to display when 'auto-restore-windows-show-messages is t"
  :type 'string
  :group 'auto-restore-windows)

(defcustom  auto-restore-windows-message-loaded "window config loaded"
  "The string to display when 'auto-restore-windows-show-messages is t"
  :type 'string
  :group 'auto-restore-windows)

(defun auto-restore-windows-reset ()
  "Reset all AUTO-RESTORE-WINDOWSindows settings"
  (interactive)
  (setq auto-restore-windows-configuration ()))

(defun auto-restore-windows-save-window (&optional all-in-frame)
  "Save the current configuration, optionally setting this
configuration for each window in the frame"
  (interactive "P")
  (let ((current (current-window-configuration)))
    (add-to-list 'auto-restore-windows-configuration `(,(buffer-name) . ,current))
    (if all-in-frame
        (walk-windows (lambda (window)
			(add-to-list 'auto-restore-windows-configuration
				     `(,(buffer-name (window-buffer window)) . ,current)))))
    (if auto-restore-windows-show-messages
	(message (concat auto-restore-windows-message-saved
			 (if all-in-frame (concat " " auto-restore-windows-message-all-buffers)))))))

(defun auto-restore-windows-clear-window (&optional all-in-frame)
  "Clear the configuration for this buffer, optionall for all
buffers in the frame"
  (interactive "P")
  (let ((buffer (buffer-name)))
    (assq-delete-all buffer auto-restore-windows-configuration) 
    (if all-in-frame
        (walk-windows (lambda (window)
			(assq-delete-all (buffer-name (window-buffer window))
					  auto-restore-windows-configuration))))
    (if auto-restore-windows-show-messages
	(message (concat auto-restore-windows-message-cleared
			 (if all-in-frame (concat " " auto-restore-windows-message-all-buffers)))))))

(defun auto-restore-windows-restore-window (buffer)
  "Restore the settings as stored in buffer"
  (interactive)
  (let ((restore (cdr (assoc buffer auto-restore-windows-configuration))))
    (if (and (boundp 'restore)
             (not (eq restore nil)))
        (progn	  
          (set-window-configuration restore))
          (if (not (equal buffer (buffer-name)))
              (pop-to-buffer buffer))
	  (if auto-restore-windows-show-messages
	      (message auto-restore-windows-message-loaded)))))

(defun auto-restore-windows-restore-window-this-buffer ()
  "Restore the windows for this buffer"
  (interactive)
  (auto-restore-windows-restore-window (buffer-name)))

(defun auto-restore-windows-window-change ()
  "Check if we've changed buffer, and if so restore the configuration"
  (let ((new-buffer (buffer-name)))
    (if (not (eq auto-restore-windows-curr-buffer new-buffer))
        (auto-restore-windows-restore-window new-buffer))
    (setq auto-restore-windows-curr-buffer new-buffer)))

(defadvice switch-to-buffer (after auto-restore-windows-window-change activate)
  "`switch-to-buffer', and then restore layout, if there is one"
  (auto-restore-windows-window-change))

(provide 'auto-restore-windows)

;; auto-restore-windows.el ends here
