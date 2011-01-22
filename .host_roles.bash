# Like host_config but can support a role for multiple hosts
CONFIG_FILE=$1
if [ -f ~/.host_roles.def ]; then
    for role in `cat ~/.host_roles.def`
    do
        #echo Loading role: $role
        if [ -f ~/host_roles/$role/$1 ]; then
            source ~/host_roles/$role/$1
        fi
    done
fi
