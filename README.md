# auto-restore-windows

auto-restore-windows.el -- automatially restore window configuration when changing into target buffers

## Description

 Load the package and bind the commands
 "auto-restore-windows-save-window" and
 "auto-restore-windows-clear-window" to something convenient,

 Executing auto-restore-windows-save-window will store the current
 window configuration and will restore the configuration when
 switching back to the buffer.

 Executing auto-restore-windows-clear-window will clear the
 configuration for the buffer.

 With the prefix operator (C-u) it will apply the settings to every
 buffer in the frame instead of just the current buffer.

 The variable "auto-restore-windows-show-messages" controls whether
 or not to echo message in the minibuffer.  This setting and the
 strings to be displayed can be edited by customizing the
 "auto-restore-windows" group.

## Usage
 Usage:
```lisp
 ;; Load the package and set the keybindings you want
 ;; I like to stick them in with the "purpose-mode" keys, as dedication
 ;; is part of the windows config that is copied and restored!

 ;; If using use-package, something like
 (use-package auto-restore-windows
  :config
  ;; C-c , C
  (bind-key "C" 'auto-restore-windows-clear-window purpose-mode-prefix-map) ;; I like these bindings, YMMV
  ;; C-c , S
  (bind-key "S" 'auto-restore-windows-save-window  purpose-mode-prefix-map))

 ;; Otherwise just require it and set your keybindings
 (require 'auto-restore-windows)
 (define-key purpose-mode-prefix-map "C" 'auto-restore-windows-clear-window)
 (define-key purpose-mode-prefix-map "S" 'auto-restore-windows-save-window)
```
