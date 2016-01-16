#! /usr/bin/env python2.7

from gtk.gdk import *
import gtk.gdk
import sys

def main():
  xlib_window_id=int(sys.argv[1])
  decoration_flags=int(sys.argv[2])

  window_handle = gtk.gdk.window_foreign_new(xlib_window_id)
  window_handle.set_decorations(decoration_flags)
  
  gtk.gdk.flush()

if __name__ == "__main__":
  main()
