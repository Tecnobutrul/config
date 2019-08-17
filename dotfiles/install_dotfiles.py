#!/usr/share/python3

import os
import subprocess

home = os.environ['HOME']
dotfiles = os.path.dirname(os.path.abspath(__file__))
print(dotfiles)

link_targets = {
    "vim": home,
    "zsh": home,
    "i3": home+"/.config/i3",
}

dot_files = ["vim", "zsh"]
non_dot_files = ["i3"]


def config_files(dir_path):
    print('carptea nova:' + dir_path)

    for element in os.listdir(dir_path):
        abs_path = os.path.join(dir_path, element)
        print(abs_path)
        if (os.path.isdir(abs_path)):
            config_files(abs_path)
        else:
            if(element != 'install_dotfiles.py'):
                if (os.path.basename(dir_path) in dot_files):
                    # Creates links on home directory
                    link = link_targets[os.path.basename(dir_path)] + "/." + element
                    subprocess.call(['ln', '-s', abs_path, link])
                    print ('Creating link for: ' + link)

                else:
                    # Creates link based on directory name
                    link = os.path.join(link_targets[os.path.basename(dir_path)], element)
                    # If link directory doesn't exists, create it
                    if(not os.path.exists(os.path.dirname(link))):
                        subprocess.call(['mkdir', '-p', os.path.dirname(link)])
                    subprocess.call(['ln', '-s', abs_path, link])
                    print ('Creating link for: ' + link)


config_files(dotfiles)
