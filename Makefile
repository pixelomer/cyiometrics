TARGET = iphone:10.3:8.0
ARCHS = arm64e arm64 armv7

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Cyiometrics
Cyiometrics_FILES = Tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk


