# ACADProp
This is a bunch of lisp scripts to help with generating Naval Architecture drawings. Developed in 2009, Uploaded for backup and might be useful for someone. 

Instructions to Generate Propeller Drawings:
Unzip all files to D:/
(important. do not put in any folders, just in d:/)

From autocad, goto tools and load application.

load the prop.lsp file from d:/

To run application, in command line, type propeller and click  enter. 

Enter data as required. 


Instructions to get line coordinates:
1.The relevant file is getxy.lsp
2.Open autocad
3.write command "appload"
4.goto the place where u saved the file and open it
5.Set you orgin to Center line of body plan
6.type the command "offsets"
7.then click on the points for which u need y values
8.you can only get 10 points at a time.
9.After that go to D:/  there will be a file offsets.TXT it will have
half breadth values.
