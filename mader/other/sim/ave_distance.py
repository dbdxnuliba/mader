#!/usr/bin/env python  
# Kota Kondo

#  Commands: Open three terminals and execute this:
#  python collision_check.py

#Whenever you want, you can ctrl+C the second command and you will get the absolute and relative velocities

import bagpy
from bagpy import bagreader
import pandas as pd

import rosbag
import rospy
import math
import tf2_ros
import geometry_msgs.msg
import tf
import numpy as np
import matplotlib.pyplot as plt
import os
import glob

if __name__ == '__main__':

    # rosbag name

    # Dont use ~ like this
    cd = "50" # [ms] communication delay

    is_oldmader = False # change here 
    
    if is_oldmader:
        dc_list = [0, 170, 78, 63, 55, 51] #dc_list[0] will be used for old mader (which doesn't need delay check) so enter some value (default 0)
    else:
        # dc_list = [170, 78, 63, 55, 51] #dc_list[0] will be used for old mader (which doesn't need delay check) so enter some value (default 0)
        dc_list = [51] #dc_list[0] will be used for old mader (which doesn't need delay check) so enter some value (default 0)


    for dc in dc_list:

        if is_oldmader:
            source_dir = "/home/kota/data/bags/oldmader/cd"+cd+"ms" # change the source dir accordingly #10 agents
        else:
            source_dir = "/home/kota/data/bags/rmader/cd"+cd+"msdc"+str(dc)+"ms" # change the source dir accordingly #10 agents
        
        source_len = len(source_dir)
        source_bags = source_dir + "/*.bag" # change the source dir accordingly

        rosbag_list = glob.glob(source_bags)
        rosbag_list.sort() #alphabetically order
        rosbag = []

        for bag in rosbag_list:
            rosbag.append(bag)

        for i in range(len(rosbag)):

            b = bagreader(rosbag[i], verbose=False)
            sim_id = rosbag[i][source_len+5:source_len+7]
            
            log_data = b.message_by_topic("/is_collided")
            if (log_data == None):
                print("sim " + sim_id + ": no collision" )
                os.system('echo "simulation '+sim_id+': no collision" >> '+source_dir+'/collision_status.txt')
            else:
                print("sim " + sim_id + ": ******collision******" )
                os.system('echo "simulation '+sim_id+': ***collision***" >> '+source_dir+'/collision_status.txt')

        os.system('paste '+source_dir+'/collision_status.txt '+source_dir+'/status.txt >> '+source_dir+'/complete_status.txt')

        is_oldmader = False