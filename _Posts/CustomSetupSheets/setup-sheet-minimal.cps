/**
  Copyright (C) 2012-2021 by Autodesk, Inc.
  All rights reserved.

  Setup sheet configuration.

  $Revision: 44178 f1aec0e4ff56095aa9aa894a8daf90b9915992c3 $
  $Date: 2022-11-10 15:20:20 $

  FORKID {BC98C807-412C-4ffc-BD2B-ABB3F0A59DB8}
*/

description="Minimal test1";
vendor = "Autodesk";
vendorUrl = "http://www.autodesk.com";
legal = "Copyright (C) 2012-2021 by Autodesk, Inc.";
certificationLevel = 2;

longDescription = "Setup sheet for generating an HTML document with the relevant details for the setup, tools, and individual operations. You can print the document directly or alternatively convert it to a PDF file for later reference.";

capabilities = CAPABILITY_SETUP_SHEET;
extension = "html";
mimetype = "text/html";
keywords = "MODEL_IMAGE PREVIEW_IMAGE";
setCodePage("utf-8");
dependencies = "setup-sheet.css";

allowMachineChangeOnSection = true;

properties=
{
    testProp:
    {
        title:"testTitle",
        description:"Desc",
        type:"boolean",
        value:false,
        scope:"post"
    }
};

function onOpen()
{
  writeln("<html>test!</html>");
}

function onSection()
{

}

function onSectionEnd() 
{
  
}

function onClose()
{

}

function onTerminate()
{

}