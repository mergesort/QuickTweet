GO_EASY_ON_ME = 1

include theos/makefiles/common.mk

TWEAK_NAME = QuickTweet
QuickTweet_FILES = Tweak.x
QuickTweet_FRAMEWORKS = UIKit CoreGraphics Twitter

include $(THEOS_MAKE_PATH)/tweak.mk