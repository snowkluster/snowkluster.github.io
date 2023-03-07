---
title: "OverTheWire Natas Levels 01-05"
date: 2022-11-17T21:56:39+05:30
tags: ['update','Wargame','CTF']
series: "NATAS"
---

# Natas as a Start 

Over the next few weeks, I will try and post a complete walkthrough guide for the **Natas** war game that you can play over at [OverTheWire](https://overthewire.org/wargames/natas/).  The **Natas** is a war game based around web exploitation and pentesting, to start playing **Natas** we can simply visit the url and enter the password given to us. (Note: As we complete a room in these Wargames we are given the password to access the next room and move forward in a journey) 

![](/Blog2/Natas0-start.webp)

Anyway, let's start with **_Natas_**

## LEVEL 00
We are given the [URL](http://natas0.natas.labs.overthewire.org/) and the login username and password for the page (_natas0_). The objective of the Room is to find the password for the next room, add the landing page also tells us about it

![](/Blog2/Natas0-home-info.webp)

We can see there is nothing else present on the page, so let's view the page source instead, and there amongst the ``HTML`` we can the password for the next

![](/Blog2/Natas0-password.webp)

Moving right along...

## LEVEL 01
Moving on to the next room, we enter the username "*_natas1_*" and the password we got from the last room. We are greeted with this bit of information 

![](/Blog2/natas1-home-info.webp) 

and trying to right-click lead to JavaScript alert telling us

![](/Blog2/natas1-rightclick-result.webp)

As the page still seem mostly empty, let's try looking at the source by pressing <kbd>Ctrl</kbd>  + <kbd>u</kbd>. This show us the password for the next room.

![](/Blog2/natas1-password.webp)

## LEVEL 02
We know the routine now and immediately start looking at the page source. We can see amongst the ``HTML``  an ``img``  tag which is referencing an image named "_pixel.png_".

![](/blog2/natas2-img-html.webp)

If we visit this image, we can see a blank page, but the interesting thing is that we are now in a subdirectory called ``http://natas2.natas.labs.overthewire.org/files/pixel.png``
if we go back a directory, we find our self at an index of all the files used in the page and with it a **Directory listing vulnerability**

![](/Blog2/natas2-index.webp) 

we can see a file called users.txt that has the contents:
``# username:password``

``alice:BYNdCesZqW``

``bob:jw2ueICLvT``

``charlie:G5vCxkVV3m``

``natas3:G6ctbMJ5Nb4cbFwhpMPSvxGHhQ7I6W8Q``

``eve:zo4mJWyNj2``

``mallory:9urtcpzBmH``

and we find our next password.

## LEVEL 03
If we view the page source, we can see that it says 
``<!-- No more information leaks!! Not even Google will find it this time... -->``

that means we google's crawlers are not able to find it.
We can look over at robots.txt file to find **/s3cr3t/** that all crawlers are told to ignore, 
going to **/s3cr3t/** show another index page with a users.txt file and hence giving us our password.

**_natas4:tKOcJIbzM4lTs8hbCmzn5Zr4434fGZQm_**

## LEVEL 04
The landing page tells us that we are visiting from ``'' ''``  and only users coming from **"http://natas5.natas.labs.overthewire.org/"** are authorized, and we don't have access to **natas5**. If we refresh the page, it now tells use that we are coming from ``http://natas4.natas.labs.overthewire.org/``. 
If we intercept the page request using burp suite and send it to the repeater, we can see the ``referer`` header says that we are coming from the **natas4** website. As we have intercepted the request using burp suite, we can now change the ``referer`` header to **"http://natas5.natas.labs.overthewire.org/"** 

![](/Blog2/natas4-referer.webp)

the response gives us the password

![](/Blog2/natas4-ans.webp)

## LEVEL 05
The landing page tells us that ``Access disallowed. You are not logged in`` and viewing the page source also doesn't reveal anything. If we view the request in ``Burp`` we can see that the there is a cookie in play called ``Cookie: loggedin=0`` that has its value set to 0 (or ``FALSE``). If we change the value of this cookie to 1 (or ``TRUE``)

(doing a ``Cookie Based Authentication Vulnerabilities``)
we can see in the response tab the password for the next room.

**``fOIvE0MDtPTgRhqmmvvAOt2EfXR6uQgR``**

### More to come

I will be posting the solutions to natas6 through natas12, hopefully by next week, gives me a good reason to visit these war games again