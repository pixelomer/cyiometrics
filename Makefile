THEOS_DEVICE_IP = 0
THEOS_DEVICE_PORT = 2222
TARGET = iphone:10.3:8.0
ARCHS = arm64 armv7s armv7

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Cyiometrics
Cyiometrics_FILES = Tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk


