---
title: "OverTheWire Natas Levels 06-12"
date: 2022-11-20T23:37:50+05:30
tags: ['update','Wargame','CTF']
series: "NATAS"
---

# More To Learn

Moving on to the next batch of war rooms, the challenges get a bit more technical and a bit more fun. So let's continue, shall we…

## LEVEL 06

**Natas6** start us off by asking for a secret password and if we enter the wrong password it gives us an error message.

![](/Blog3/natas-6-home.png)

if we view the source we can see the verification function that is used here, and we can see that it in the ``PHP`` code it includes a file called ``/includes/secret.inc`` if we visit the page in our browser we see an empty page but viewing the source reveals the password need to pass verification ``FOEIUWGHFEEUHOFUOIU``. When we enter the secret in the homepage, and we get the password required to access the next room.

The password is ``jmxSiH3SP6Sonf8dv66ng8v1cIEdjXWr``.

## LEVEL 07

When we first connect to the page, we see two links that leads to

![](/Blog3/natas7-home.png)

and

![](/Blog3/natas7-about.png)

When we view the page source for both these pages, we see a comment left behind, giving us a hint.

``hint: password for webuser natas8 is in /etc/natas_webpass/natas8``

We also see that when we click on any of the hyperlinks, the URL of the page changes to 

``index.php?page=home``.

This could mean that these pages are loaded in using an include function in ``PHP`` and that could lead us to a **local file inclusion vulnerability**

If we enter the file path that the clue gave us, it leads to a new page giving us the next password.

![](/Blog3/natas7-pass.png)

## LEVEL 08

Level 8 starts off similar to level 6 asking us for a password. Viewing the source shows us the verification method used.

![](/Blog3/natas8-encode.png)

We can see that it takes our password, does a few operations on it and then compares it to the ``$encodedSecret = "3d3d516343746d4d6d6c315669563362"``.

So to crack the password if simply perform the operations in reverse order on the ``$encodedSecret``.

Firstly we convert the ``$encodedSecret"`` from ``bin2hex`` then reverse the string that we get and finally decode the ``base64`` output leaving us with the

secret ``oubWYf2kBq`` and the password to next level ``Sda6t0vkOPkM8YeOZkAGVhFoaplvlJFd``.

## LEVEL 09

This room is a great example to learn about command injections. The homepage contains a search box which returns all the string that match the user entered string.

![](/Blog3/natas9-home.png)

Viewing the source shows us that the search function essentially runs the Linux command ``passthru("grep -i $key dictionary.txt");`` on the given user string using the ``PHP`` command ``passthru``, this is the key to cracking this room. As the ``passthru`` function does no check on the user input, we can use it to run our own commands. To run multiple commands on Linux simultaneously, we use the ``;`` symbol telling the shell that the command following the ``;`` symbol need to execute regardless of the success of the first command. By doing this, we can view all the files and folders present on the machine.

![](/Blog3/natas9-all-files.png)

We know from the **Natas** start page that ``All passwords are also stored in /etc/natas_webpass/`` so we can go to file location ``/etc/natas_webpass/natas10`` to get the password to the next room. We can use the payload ``; cat /etc/natas_webpass/natas10`` to view the contents of the file __natas10__. This gets us the password for the next room ``D44EcsFkLxPIkAAKLosx8z3hxX1Z4MCE``. To make the output of our payload cleaner we can use the ``#`` symbol that is used to trim string and comment out the rest of command output (which in our case the output of the command ``grep -i $key dictionary.txt``)

![](/Blog3/natas9-fin-pay.png)

## LEVEL 10

This level is pretty similar to level nine but with more security features. Now before our query gets passed to the ``passthru`` function it is checked against regex to see if there are illegal characters in use ``if(preg_match('/[;|&]/',$key))``. To circumvent this, we can use skip the use of ``; cat`` and directly exploit the function, as it still use grep. We can pass a query like 
``.* /etc/natas_webpass/natas11 #`` telling grep to get the content of the file natas11 located at given directory and ignore the rest of output (this will shorten our result as the output of grep -i dictionary is droped by bash).

Therefore the key is ``1KFqoJXi6hRaPluAmk8ESDW4fSysRoIg``


![](/Blog3/natas11-ans.png)

## LEVEL 11

