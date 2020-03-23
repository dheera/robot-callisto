#!/usr/bin/env python3

import rospy
import time
from std_msgs.msg import Int16MultiArray

if __name__ == "__main__":
    rospy.init_node("roboteq_test_node")

    pub_command = rospy.Publisher("/motor/command", Int16MultiArray, queue_size = 1)

    msg = Int16MultiArray()

    MAX = 200

    for i in range(MAX):
        msg.data = [i,i]
        pub_command.publish(msg)
        time.sleep(0.02)

    for i in reversed(range(MAX)):
        msg.data = [i,i]
        pub_command.publish(msg)
        time.sleep(0.02)

    for i in range(MAX):
        msg.data = [-i,-i]
        pub_command.publish(msg)
        time.sleep(0.02)

    for i in reversed(range(MAX)):
        msg.data = [-i,-i]
        pub_command.publish(msg)
        time.sleep(0.02)
