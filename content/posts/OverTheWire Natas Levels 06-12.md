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


![](/Blog3/natas10-ans.png)

## LEVEL 11

From this level onwards, the challenges focus on more complex topics and exploits. For this challenge, we are given a text box in accepts hex colour values and changes the background colour accordingly. 

![](/Blog3/natas11-home.png)

Looking at the source code, we see an array declared at the start,

```$defaultdata = array( "showpassword"=>"no", "bgcolor"=>"#ffffff");```

Followed by three functions.

![](/Blog3/natas11-src.png)

Analysing the source code, we see that the ``loaddata`` function is passed the ``defaultdata`` array, the function sets a global cookie and passes the value of ``defaultdata`` to ``mydata``. It then checks the cookie to see if it's an array and that this array contains a key value called data. If data exists then the key value of data from the cookie is decoded from base64 passed to the XOR function and then finally decoded from JSON as the XOR function would return PHP code and stored in ``tempdata``. Check are then made to see if ``tempdata`` is an array and that it contains the keys ``showpassword`` and ``bgcolor`` and that ``bgcolor`` is not greater than 6 characters.


If the conditions are met, the value of ``mydata`` is changed and returned. The save data function sets the cookie via,

```setcookie("data", base64_encode(xor_encrypt(json_encode($d))));```


This leaves us with the final function to analyse the ``xor_encrypt`` function. It takes the array passed to it and XOR each element of the array with the elements of the key is the following way:

![](/Blog3/natas11-xor.png)

So to get the password to the next level, we need to set the array key value of **showpassword** to __yes__. We know that the value for the array is read from the cookie and that the cookie is XOR encrypted. But XOR is a flawed encryption technique as, if one know any two of the values used in the function, they are able to derive the third value.

**Plaintext ⊕ key = encrypted_text**

**encrypted_text ⊕ plaintext = key**

**encrypted_text ⊕ key = plaintext**

Where  ⊕ denotes the [exclusive disjunction](https://en.wikipedia.org/wiki/Exclusive_disjunction) (XOR) operation.

We can see the current cookie by typing ``document.cookie`` into the console, this gives the value of 
**"data=MGw7JCQ5OC04PT8jOSpqdmkgJ25nbCorKCEkIzlscm5oKC4qLSgubjY%3D"**.  

Since all cookies are URL encoded by the web server, we first need to decode it from the URL format. We can further see from the ``loaddata`` function  that this value need to be decoded from Base64 before passing it to the XOR function. 

![](/Blog3/natas11-url-b64.png)

Now,  to find the key used in the XOR function which is censored in the given source code, 

![](/Blog3/natas11-censor.png)

we first need to take the decode output and pass that as an input to the XOR function.  For the key, we need to pass the value of the array that's stored in the cookie, as that's the Plain text.

```$defaultdata = array( "showpassword"=>"no", "bgcolor"=>"#ffffff");```

But these values are stored as PHP code, to get the real Plain text value we need to encode it to JSON like in the save data function. Doing this will lend us the real key used in the XOR cipher as, 

**encrypted_text ⊕ plaintext = key**

The key Being **KNHLKNHLKNHLKNHLKNHLKNHLKNHLKNHLKNHLKNHLK**, but this isn't the real key, as we can see the value __KNHL__ is being repeated over and over again this happens when the keys used in XOR is shorter than the Plain text. So the real key is **KNHL**

Now, using this key we can forge a new cookie where the value ``showpassword`` is set to true  and then all we need to do to get the flag is inject this malformed cookie and refresh the page. 
Given us the password to next level ``YWqo0pjpcXzSIl5NMAVxg12QxeC1w9QG``

![](/Blog3/natas11-ans.png)


## Finishing OFF

I will be posting the solutions to natas13 through natas18, hopefully soon...