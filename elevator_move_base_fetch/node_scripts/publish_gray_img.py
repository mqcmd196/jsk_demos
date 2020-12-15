#!/usr/bin/env python

import rospy
from cv_bridge import CvBridge
import cv2

from sensor_msgs.msg import Image
from sensor_msgs.msg import CameraInfo

class RGB2Gray:
    def __init__(self):
        rospy.init_node('rgb2gray', anonymous=True)
        self.img_sub = rospy.Subscriber('/head_camera/rgb/image_rect_color', Image, self.img_callback)
        self.info_sub = rospy.Subscriber('/head_camera/rgb/camera_info', CameraInfo, self.info_callback)
        self.img_pub = rospy.Publisher('/head_camera/mono/image_rect', Image, queue_size=1)
        self.info_pub = rospy.Publisher('/head_camera/mono/camera_info', CameraInfo, queue_size=1)
        self.bridge = CvBridge()

    def img_callback(self, data):
        cv2_img = self.bridge.imgmsg_to_cv2(data, "bgr8")
        gray_img = cv2.cvtColor(cv2_img, cv2.COLOR_BGR2GRAY)
        gray_msg = self.bridge.cv2_to_imgmsg(gray_img, "mono8")
        self.img_pub.publish(gray_msg)

    def info_callback(self, data):
        self.info_pub.publish(data)

if __name__ == '__main__':
    try:
        node = RGB2Gray()
        while not rospy.is_shutdown():
            rospy.sleep(0.1)
    except rospy.ROSInterruptException:
        pass
