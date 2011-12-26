#Thanks vte for the example!

catalogdir = $(GLADE_CATALOG_DIR)
catalog_DATA = gtkmusic-catalog.xml

icons = \
	hicolor_actions_16x16_widget-gtkmusic-guitar.png \
	hicolor_actions_22x22_widget-gtkmusic-guitar.png \
	hicolor_actions_16x16_widget-gtkmusic-piano.png \
	hicolor_actions_22x22_widget-gtkmusic-piano.png

EXTRA_DIST = \
	$(catalog_DATA) \
	$(icons)

install-icons:
	for icon in $(icons); do \
		THEME=`echo $$icon | cut -d_ -f1`; \
		CONTEXT=`echo $$icon | cut -d_ -f2`; \
		SIZE=`echo $$icon | cut -d_ -f3`; \
		ICONFILE=`echo $$icon | cut -d_ -f4`; \
		mkdir -p $(DESTDIR)$(GLADE_ICON_DIR)/$$THEME/$$SIZE/$$CONTEXT; \
		$(INSTALL_DATA) $(srcdir)/$$icon $(DESTDIR)$(GLADE_ICON_DIR)/$$THEME/$$SIZE/$$CONTEXT/$$ICONFILE; \
	done

uninstall-icons:
	-for icon in $(icons); do \
		THEME=`echo $$icon | cut -d_ -f1`; \
		CONTEXT=`echo $$icon | cut -d_ -f2`; \
		SIZE=`echo $$icon | cut -d_ -f3`; \
		ICONFILE=`echo $$icon | cut -d_ -f4`; \
		rm -f $(DESTDIR)$(GLADE_ICON_DIR)/$$THEME/$$SIZE/$$CONTEXT/$$ICONFILE; \
	done

validate: $(catalog_DATA)
	xmllint --dtdvalid glade-catalog.dtd --noout $<

install-data-local: install-icons
uninstall-local: uninstall-icons

MAINTAINERCLEANFILES = $(catalog_DATA)
