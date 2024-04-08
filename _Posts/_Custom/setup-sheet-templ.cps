/**
 * Setup sheet config
 * Minimal framework only
 * 
 * Run within cam to produce a html setup page
 * FabLab WS
 * 
 * Benjamin Solar
 * 23-03-2024
 * 
 * TODO:
 * Pattern support - cached
 * Manual nc support - cached
 */

description="Setup Template";
vendor = "FabLabWS";
vendorUrl = "hh.se";
certificationLevel = 2;

longDescription = "Setup sheet template";

capabilities = CAPABILITY_SETUP_SHEET;
extension = "html";
mimetype = "text/html";
keywords = "MODEL_IMAGE PREVIEW_IMAGE";
setCodePage("utf-8");
dependencies = "setup-sheet-templ-style.css";

allowMachineChangeOnSection = true;

properties=
{
    
};

var xyzFormat = createFormat({decimals:(unit == MM ? 3 : 4)});
var feedFormat = createFormat({decimals:(unit == MM ? 3 : 5)});
var toolFormat = createFormat({decimals:0});
var rpmFormat = createFormat({decimals:0});
var secFormat = createFormat({decimals:3});
var angleFormat = createFormat({decimals:0, scale:DEG});
var degFormat = createFormat({decimals:0});
var pitchFormat = createFormat({decimals:3});
var spatialFormat = createFormat({decimals:(unit == MM ? 2 : 3)});
var percentageFormat = createFormat({decimals:1, scale:100});
var timeFormat = createFormat({decimals:2});
var taperFormat = angleFormat; // share format

var supportedImageTypes = 
{
    "bmp" : "image/bmp",
    "gif" : "image/gif",
    "jpg" : "image/jpeg",
    "jpeg": "image/jpeg",
    "png" : "image/png",
    "tif" : "image/tiff",
    "tiff": "image/tiff"
};

function htmlSetup()
{
    write(
    "<!DOCTYPE html> \n" +
    "<html> \n" +
    " <head> \n" +
    "<style type=\"text/css\"> \n" +
    loadText("setup-sheet-templ-style.css","utf-8") + "\n" +
    "</style> \n" +
    "   <title>Setup sheet templ</title> \n" +
    " </head> \n" +
    " <body> \n" +
    "  <div class=\"main-page\"> \n" +
    "    <div class=\"sub-page\"> \n");
}

function htmlEnd()
{
    write(
    "      </div> \n" +
    "   </div> \n" +
    " </body> \n" +
    "</html> \n");
}

function divS(dClass, dText, dStyle) //div start
{

}

function divE() //div end
{

}

function divSE(dClass, dText, dStyle) //div start and end
{

}

/** Loads the given image as a img data snippet. Returns empty string if unsupported. */
function getImageAsImgSrc(path) 
{
    if ((typeof BinaryFile == "function") && (typeof Base64 == "function")) {
      var extension = path.slice(path.lastIndexOf(".") + 1, path.length).toLowerCase();
      var mimetype = supportedImageTypes[extension];
      if (mimetype) {
        var data = BinaryFile.loadBinary(path);
        return "data:" + mimetype + ";base64," + Base64.btoa(data);
      }
    }
    return "";
}

function modelImg() //Insert model image
{
    var path = FileSystem.getCombinedPath(FileSystem.getFolderPath(getOutputPath()), modelImagePath);
    imgSrc=getImageAsImgSrc(path);
    FileSystem.remove(path);

    writeln("<img src=\"" + imgSrc + "\" alt=\"Model image\" width=\"50%\"/>");
}

function tableS(tClass, tStyle) //Table start
{
    if(typeof tStyle === "undefined") //No additional style
    {
        writeln("<table class=\"" + tClass + "\">");
    }
    else //With additional style
    {
        writeln("<table class=\"" + tClass + "\" style=\"" + tStyle + "\">");
    }
}

function tableE() //Table end
{
    writeln("</table>");
}

function tableRowS() //Table row start
{
    writeln("<tr>");
}

function tableRowE() //Table row end
{
    writeln("</tr>");
}

function tableHead(tText) //Table header
{
    writeln("<th>" + tText + "</th>");
}

function tableCell(tText) //Table cell
{
    writeln("<td>" + tText + "</td>");
}

function writeToolTable() //Write html tool table
{
    var tools=getToolTable();

    for(var i=0; i < tools.getNumberOfTools(); ++i)
    {
        var tool=tools.getTool(i);
        var toolDia=tool.diameter;
        writeln("<h2>Diameter: " + toolDia + "</h2>");
    }

    tableS("topTable");
        tableRowS();
            tableCell("Test1");
            tableCell("Test2");
        tableRowE();
        tableRowS();
            tableCell("Test1");
            tableCell("Test2");
        tableRowE();
    tableE();
}

function writePathTable() //Write html toolpath table
{
    var pathId=currentSection.getId();
    var descr=getParameter("operation-strategy");
    var cmt=getParameter("operation-comment");
    var cTool=currentSection.getTool();

    writeln("<h2>T" + cTool.number + " | " + cmt + "</h2>");
}

function onOpen() //On init of post
{
    htmlSetup();
    modelImg();
}

function onSection() //On start of section
{

}

function onSectionEnd() //On end of section
{
    if(isFirstSection())
    {
        writeln("<h2>" + programName + "</h2>");
        writeln("<h2>" + programComment + "</h2>");

        var workpiece=getWorkpiece();
        var stockDim=Vector.diff(workpiece.upper, workpiece.lower);
        var lower = new Vector(getParameter("part-lower-x"), getParameter("part-lower-y"), getParameter("part-lower-z"));
        var upper = new Vector(getParameter("part-upper-x"), getParameter("part-upper-y"), getParameter("part-upper-z"));
        var partDim=Vector.diff(upper, lower);
        var cWorkOfs=currentSection.workOffset;

        writeln("<h2>" + cWorkOfs + "</h2>");
        writeln("<h2>" + "Stock:" + spatialFormat.format(stockDim.x) + " " + spatialFormat.format(stockDim.y) + " " + spatialFormat.format(stockDim.z) + "</h2>");
        writeln("<h2>" + "Part:" + spatialFormat.format(partDim.x) + " " + spatialFormat.format(partDim.y) + " " + spatialFormat.format(partDim.z) + "</h2>");

        writeToolTable();
    }
    writePathTable();
}

function onClose() //On close of post
{
    htmlEnd();
}

function onTerminate()
{

}