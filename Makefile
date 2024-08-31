include $(TOPDIR)/rules.mk

PKG_NAME:=supervisor
PKG_VERSION:=4.2.5
PKG_RELEASE:=5

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://codeload.github.com/Supervisor/supervisor/tar.gz/$(PKG_VERSION)?
PKG_HASH:=d612a48684cf41ea7ce8cdc559eaa4bf9cbaa4687c5aac3f355c6d2df4e4f170

PKG_LICENSE_FILES:=LICENSES.txt

PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/package.mk

define Package/supervisor
	SECTION:=utils
	CATEGORY:=Utilities
	URL:=https://github.com/Supervisor/supervisor
	PKGARCH:=all
	TITLE:=Supervisor process control system
	DEPENDS:= \
		+python3-light \
		+python3-decimal \
		+python3-email \
		+python3-idna \
		+python3-urllib
endef

define Package/supervisor/description
	Supervisor is a client/server system that allows its users to monitor and control a number of processes on UNIX-like operating systems.
endef

define Package/supervisor/conffiles
	/etc/config/supervisor
	/etc/supervisor.d/
endef

define Build/Compile
	cd $(PKG_BUILD_DIR) && python3 setup.py install --prefix=/usr --root=$(PKG_INSTALL_DIR)
endef

define Package/supervisor/install
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./root/etc/init.d/supervisor $(1)/etc/init.d/
	$(INSTALL_DIR) $(1)/etc/uci-defaults
	$(INSTALL_BIN) ./root/etc/uci-defaults/supervisor $(1)/etc/uci-defaults/
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/supervisord $(1)/usr/bin/
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/supervisorctl $(1)/usr/bin/
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/pidproxy $(1)/usr/bin/
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/* $(1)/usr/lib/
	find $(1)/usr/bin/ -type f -exec sed -i '1s|.*|#!/usr/bin/env python3|' {} +
endef

$(eval $(call BuildPackage,supervisor))
