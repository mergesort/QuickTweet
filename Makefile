include theos/makefiles/common.mk

TWEAK_NAME = QuickTweet
QuickTweet_FILES = Tweak.x
QuickTweet_FRAMEWORKS = UIKit CoreGraphics Twitter

include $(THEOS_MAKE_PATH)/tweak.mk