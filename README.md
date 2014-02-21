#QEMU Internet Explorer VMs

A way to easily run multiple IE virtual machines at the same time, allowing
connections to them over VNC. This takes advantage of KVM to ensure that the
virtualization is fast and QEMU to manage the vms, which provides built-in VNC
support.

------

##Getting Files

You can download VMs with different versions of Internet Explorer from
[modern.ie](http://modern.ie/). Choose the Linux VirtualBox VMs. It will
download a self-extracting archive, which will extract to a `.ova` file. Untar
this by renaming to `.tar` and using `tar -xf file.tar`. Finally, you will be
left with a `.vmdk` file and a `.ovf` file. Delete the `.ovf` file and rename
the vmdk to just be `IE##.vmdk`, where the `##` is the version of Internet
Explorer on the VM (for example, `IE8.vmdk`). You can do this for as many
different versions of IE as you want.

##Setup

Once you have the `.vmdk` files, use the manage script to perform setup, by
running `./manage.sh setup IE##`. This will create an overlay hard disk for the
IE vm. That's it for setup!

##Running

To run the VMs you need to have QEMU and KVM installed, and ensure that your
system supports KVM. (Note, you don't actually have to use KVM, but the
virtualization will be much much slower, because it defers to software
virtualization). You can probably install both from your package manager. On
Ubuntu, `qemu-kvm` is the main package, on Arch Linux it is `qemu`.

To run a VM, run `./manage.sh start IE##`. This will both start the VM
and setup the VNC server, listening on a port number corresponding to the
version of IE that you are using (i.e. `./manage.sh start IE8` will start a
server on port 8).

To stop a VM, run `./manage.sh stop IE##`. Note that this will hard-reset the
machine, so the Windows installation might not be very happy about it.

## Connecting

To connect to the server over VNC, connect using a VNC server to the IP address
of the computer the VMs are running on, with display/port equivalent to the
version of Internet Explorer you want to use. So, if the server is running on
`192.168.0.200` and you want to use Internet Explorer 8, you would connect to
[vnc://192.168.0.200:8](vnc://192.168.0.200:8).

##Resetting

If you are using the VMs from modern.ie, after several months they will start
complaining that the version of Windows isn't activated, and will start
shutting down every hour. To solve this problem, just run `./manage.sh reset
IE##`, which will re-create the overlay hard disk, and should stop Windows from
complaining. Note that this will also reset all the settings for the VM.
