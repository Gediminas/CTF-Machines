if [ ! -d "../res" ]; then
    echo Creating "../res" folder
    mkdir -p ../res
fi

if [ ! -d "../work" ]; then
    echo Creating "../work" folder
    mkdir -p ../work
fi

vagrant up --provision
vagrant ssh -c "xfconf-query -c  xfce4-session -p '/general/lock_on_suspend -n -t bool -s false'"
vagrant ssh -c "xfconf-query -c  xfce4-session -p '/shutdown/LockScreen -n -t bool -s false'"



