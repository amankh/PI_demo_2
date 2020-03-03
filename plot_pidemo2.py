#!/usr/bin/env python
import rospy
import ackermann_msgs.msg
import geometry_msgs.msg
import nav_msgs.msg


import matplotlib
import matplotlib.pyplot as plt
import numpy as np
import pdb as pdb


odom_msg =[]
cmd_msg = []
waypoint_msg = []
plt_verdict = []
ctrl_verdict = []

plt.ion()

plt.show(block=True)
fig1 = plt.figure(1)
# # plotting position
sf1 = fig1.add_subplot(121)
sf1.set_xlim([-2,4])
sf1.set_ylim([-2,4])

# plotting monitor
sf2 = fig1.add_subplot(122)
sf2.set_xlim([0,200])
sf2.set_ylim([0,2000])





# class Visualizer():
#     def __init__(self):
#         plt.ion()
#         plt.show(block=True)
#         self.fig1 = plt.figure(1)
#         # # plotting position
#         self.sf1 = self.fig1.add_subplot(111)
#         # sf1.set_xlim([-2,4])
#         # sf1.set_ylim([-2,4])

#         # # plotting monitor
#         # sf2 = fig1.add_subplot(122)
#         # sf2.set_xlim([0,200])
#         # sf2.set_ylim([0,2000])


def odometry_callback(state_t):

    pos_x = state_t.pose.pose.position.x
    pos_y = state_t.pose.pose.position.y
    odom_msg.append([pos_x, pos_y])
    print('odom :', len(odom_msg))
        #plt.plot(pos_x, pos_y, '*')
        #plt.draw()
    #sf1.cla()    
    #sf1.plot(pos_x, pos_y, 'g*')
    #fig1.canvas.draw()
    #plt.pause(0.1)
    # if len(odom_msg)%10 ==0:
    #     generate_plots()

    #draw_monitor()


def generate_plots():
    #sf1.cla()
    sf1.set_xlim([-2,4])
    sf1.set_ylim([-2,4])
    sf1.plot(np.asarray(odom_msg)[-11:,0], np.asarray(odom_msg)[-11:,1], 'r-')

    draw_monitor()
    fig1.canvas.draw()




def planner_cmd_callback(cmd_t):

    speed = cmd_t.drive.speed
    st_angle = cmd_t.drive.steering_angle
    cmd_msg.append([speed, st_angle])
    print('Cmd :', len(cmd_msg))


def planner_wpt_callback(wpt_t):
    waypoint_msg.append([wpt_t.x, wpt_t.y])
    print('WP :', len(waypoint_msg))
    


def ctrl_verdict_callback(ctr_t):

    ctrl_id = ctr_t.point.x
    ctrl_val = ctr_t.point.y
    ctrl_verdict.append([ctrl_id, ctrl_val])
    print('Ctrl Verdict :', len(ctrl_verdict))
    #draw_monitor()



def plant_verdict_callback(plt_t):
    plt_verdict.append([plt_t.point.x])
    #return NotImplementedError




def draw_monitor():
    #pdb.set_trace()
    #sf2.cla()
    #if len(odom_msg)%100 ==0:
    #    pdb.set_trace()
    sf2.text(10,1800 , 'Monitor: KeymeraX',color ='red',  fontsize=15 )
    sf2.text(10, 1650, 'Planner: CPO', color ='red',  fontsize=15 )

    sf2.text(10, 1400, 'Condition1', color='green',  fontsize=12 )
    sf2.text(10, 1300, 'Condition2', color='green',  fontsize=12 )
    sf2.text(10, 1200, 'Condition3', color='green',  fontsize=12 )
    sf2.text(10, 1100, 'Condition4', color='green',  fontsize=12 )
    sf2.text(10, 1000, 'Condition5', color='green',  fontsize=12 )
    sf2.text(10, 900, 'Condition6', color='green',  fontsize=12 )
    sf2.text(10, 800, 'Condition7', color='green',  fontsize=12 )
    sf2.text(10, 700, 'Condition8', color='green',  fontsize=12 )
    sf2.text(10, 600, 'Condition9', color='green',  fontsize=12 )
    sf2.text(10, 500, 'Condition10', color='green',  fontsize=12 )
    sf2.text(10, 400, 'Condition11', color='green',  fontsize=12 )
    sf2.text(10, 300, 'Condition12', color='green',  fontsize=12 )
    sf2.text(10, 200, 'Condition13', color='green',  fontsize=12 )
    sf2.text(10, 100, 'Condition14', color='green',  fontsize=12 )
    sf2.text(10, 00, 'Condition15', color='green',  fontsize=12 )
    #sf2.set_ylabel('ylabel')
    #if len(odom_msg) %100 ==0:

    #    fig1.canvas.draw()
    #plt.pause(0.00001)




if __name__ == '__main__':


    # fig1 = plt.figure(1)
    # # plotting position
    # sf1 = fig1.add_subplot(121)
    # sf1.set_xlim([-2,4])
    # sf1.set_ylim([-2,4])

    # # plotting monitor
    # sf2 = fig1.add_subplot(122)
    # sf2.set_xlim([0,200])
    # sf2.set_ylim([0,2000])

    #draw_monitor()

    #vis = Visualizer()

    rospy.init_node("plotter_pidemo")
    rospy.Subscriber("ekf_localization/odom", nav_msgs.msg.Odometry, odometry_callback)
    rospy.Subscriber("commands/keyboard", ackermann_msgs.msg.AckermannDriveStamped, planner_cmd_callback)
    rospy.Subscriber("aa_planner/waypoints", geometry_msgs.msg.Point, planner_wpt_callback)
    rospy.Subscriber("aa_monitor/verdict", geometry_msgs.msg.PointStamped, plant_verdict_callback)
    rospy.Subscriber("aa_quant_monitor/ctrlverdict", geometry_msgs.msg.PointStamped, ctrl_verdict_callback)

    #plt.ion()
    plt.show(block=True)
    rospy.spin()



