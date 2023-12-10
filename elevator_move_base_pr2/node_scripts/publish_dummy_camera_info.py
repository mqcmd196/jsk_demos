#!/usr/bin/env python

import rospy
from sensor_msgs.msg import CameraInfo, Image
from sensor_msgs.msg import RegionOfInterest
# from std_msgs.msg import Header

def publish_dummy_camera_info(msg):
    camera_info_msg = CameraInfo()
    camera_info_msg.header = msg.header
    camera_info_msg.height = 480
    camera_info_msg.width = 640
    camera_info_msg.distortion_model = "plumb_bob"
    camera_info_msg.D = [-0.31774, 0.09207000000000001, 0.0004, -0.00051, 0.0]
    camera_info_msg.K = [423.51537, 0.0, 319.81218, 0.0, 423.53835, 246.13077, 0.0, 0.0, 1.0]
    camera_info_msg.R = [0.9999000000000001, -0.00489, 0.01293, 0.00489, 0.99999, 1e-05, -0.01293, 6.000000000000001e-05, 0.99992]
    camera_info_msg.P = [386.17852, 0.0, 321.4065, 0.0, 0.0, 386.17852, 241.10974, 0.0, 0.0, 0.0, 1.0, 0.0]
    camera_info_msg.binning_x = 0
    camera_info_msg.binning_y = 0
    roi = RegionOfInterest()
    roi.x_offset = 0
    roi.y_offset = 0
    roi.height = 0
    roi.width = 0
    roi.do_rectify = False
    camera_info_msg.roi = roi
    pub.publish(camera_info_msg)


def main():
    global pub
    rospy.init_node("dummy_camera_info_publisher")
    pub = rospy.Publisher("/wide_stereo/left/camera_info", CameraInfo, queue_size=1)
    rospy.Subscriber(
        "/wide_stereo/left/image_rect_color",
        Image,
        publish_dummy_camera_info
    )
    rospy.spin()

main()
