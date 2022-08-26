
#!/bin/bash

# this script creates multiple windows to send goals to drons
# referred to fly script used for voxl setup, which is in /extras

# session name
SESSION=decentr_goal
WINDOW=base_station

# creates the session with a name and renames the window name
cmd="new-session -d -s $SESSION ; rename-window $WINDOW"
tmux -2 $cmd

# window number
w=0

# split tmux into 8x2
for i in {0..2}
do
	tmux select-pane -t $SESSION:$w.$i
	tmux split-window -v
	tmux select-layout -t $SESSION:$w.$i even-vertical
done

for i in 0 2 4
do
	tmux select-pane -t $SESSION:$w.$i	
	tmux split-window -h
done

# wait for .bashrc to load
sleep 1

tmux send-keys -t $SESSION:$w.0 "ssh root@nx01.local" C-m
tmux send-keys -t $SESSION:$w.1 "ssh root@nx02.local" C-m
tmux send-keys -t $SESSION:$w.2 "ssh root@nx03.local" C-m
tmux send-keys -t $SESSION:$w.3 "ssh root@nx04.local" C-m
tmux send-keys -t $SESSION:$w.4 "ssh root@nx05.local" C-m
tmux send-keys -t $SESSION:$w.5 "ssh root@nx06.local" C-m

sleep 5

# ssh each nuc
tmux send-keys -t $SESSION:$w.0 "ssh nuc1@192.168.100.1" C-m
tmux send-keys -t $SESSION:$w.1 "ssh nuc2@192.168.100.2" C-m
tmux send-keys -t $SESSION:$w.2 "ssh nuc3@192.168.100.3" C-m
tmux send-keys -t $SESSION:$w.3 "ssh nuc4@192.168.100.4" C-m
tmux send-keys -t $SESSION:$w.4 "ssh nuc5@192.168.100.5" C-m
tmux send-keys -t $SESSION:$w.5 "ssh nuc6@192.168.100.6" C-m

sleep 5

# send goals (randomly generated or position exchange)
if [ "$1" == "pos" ]; then
	tmux send-keys -t $SESSION:$w.0 "roslaunch mader position_exchange.launch mode:=1 quad:=NX01"
	tmux send-keys -t $SESSION:$w.1 "roslaunch mader position_exchange.launch mode:=2 quad:=NX02"
	tmux send-keys -t $SESSION:$w.2 "roslaunch mader position_exchange.launch mode:=3 quad:=NX03"
	tmux send-keys -t $SESSION:$w.3 "roslaunch mader position_exchange.launch mode:=4 quad:=NX04"
	tmux send-keys -t $SESSION:$w.4 "roslaunch mader position_exchange.launch mode:=5 quad:=NX05"
	tmux send-keys -t $SESSION:$w.5 "roslaunch mader position_exchange.launch mode:=6 quad:=NX06"

	# with obstacles
	# tmux send-keys -t $SESSION:$w.0 "roslaunch mader position_exchange.launch mode:=1 quad:=NX01"
	# tmux send-keys -t $SESSION:$w.2 "roslaunch mader position_exchange.launch mode:=3 quad:=NX03"
	# tmux send-keys -t $SESSION:$w.3 "roslaunch mader position_exchange.launch mode:=4 quad:=NX05"
	# tmux send-keys -t $SESSION:$w.4 "roslaunch mader position_exchange.launch mode:=8 quad:=NX08" # this is obstacle
	# tmux send-keys -t $SESSION:$w.5 "roslaunch mader position_exchange.launch mode:=2 quad:=NX07"

elif [ "$1" == "ran" ]; then
	tmux send-keys -t $SESSION:$w.0 "roslaunch mader random_goal.launch quad:=NX01"
	tmux send-keys -t $SESSION:$w.1 "roslaunch mader random_goal.launch quad:=NX02"
	tmux send-keys -t $SESSION:$w.2 "roslaunch mader random_goal.launch quad:=NX03"
	tmux send-keys -t $SESSION:$w.3 "roslaunch mader random_goal.launch quad:=NX04"
	tmux send-keys -t $SESSION:$w.4 "roslaunch mader random_goal.launch quad:=NX05"
	tmux send-keys -t $SESSION:$w.5 "roslaunch mader random_goal.launch quad:=NX06"
fi

tmux -2 attach-session -t $SESSION