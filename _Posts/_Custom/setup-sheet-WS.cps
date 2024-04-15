/**
 * Fablab WS Setup sheet
 * 
 * Run within cam to produce a html setup page
 * 
 * Benjamin Solar
 * 23-03-2024
 * 
 * TODO:
 * Pattern support - cached
 * Manual nc support - cached
 */

description="WS Setup-sheet";
vendor = "FabLabWS";
vendorUrl = "hh.se";
certificationLevel = 2;

longDescription = "Fablab WS Setup sheet";

capabilities = CAPABILITY_SETUP_SHEET;
extension = "html";
mimetype = "text/html";
keywords = "MODEL_IMAGE PREVIEW_IMAGE";
setCodePage("utf-8");
dependencies = "setup-sheet-WS-style.css";

allowMachineChangeOnSection = true;

properties=
{
    projName:
    {
        title : "Project name",
        description : "Name assigned to project",
        type : "string",
        value : "1001",
        scope : "post"
    },
    showTitleBlock:
    {
        title : "Show title block",
        description : "Show title info for OP",
        type : "boolean",
        value : true,
        scope : "post"
    },
    showSetup:
    {
        title : "Show setup info",
        description : "Show setup information for OP",
        type : "boolean",
        value : true,
        scope : "post"
    },
    showTools:
    {
        title : "Show tools",
        description : "Show list of tools for OP",
        type : "boolean",
        value : true,
        scope : "post"
    },
    showPaths:
    {
        title : "Show toolpaths",
        description : "Show list of toolpaths for OP",
        type : "boolean",
        value : true,
        scope : "post"
    },
    rapidFeed: {
        title      : "Rapid feed",
        description: "Sets the rapid traversal feedrate. Set this to get more accurate cycle times.",
        type       : "number",
        value      : 5000,
        scope      : "post"
    }
};

var xyzFormat = createFormat({decimals:2});
var feedFormat = createFormat({decimals:(unit == MM ? 3 : 5)});
var toolFormat = createFormat({decimals:0});
var rpmFormat = createFormat({decimals:0});
var secFormat = createFormat({decimals:3});
var angleFormat = createFormat({decimals:0, scale:DEG});
var degFormat = createFormat({decimals:0});
var pitchFormat = createFormat({decimals:3});
var spatialFormat = createFormat({decimals:2});
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
    loadText("setup-sheet-WS-style.css","utf-8") + "\n" +
    "</style> \n" +
    "   <title>Setup sheet</title> \n" +
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

function divS(dClass, dStyle) //div start
{
    write("<div class=\"" + dClass + "\"");
    if(typeof dStyle !== "undefined") write(" style=\"" + dStyle + "\"");
    
    writeln(">");
}

function divE() //div end
{
    writeln("</div>");
}

function divSE(dClass, dText, dStyle) //div start and end
{
    write("<div class=\"" + dClass + "\"");
    if(typeof dStyle !== "undefined") write(" style=\"" + dStyle + "\">");
    else write(">");
    if(typeof dText !== "undefined") write(dText);

    writeln("</div>");
}

function writeImg(iStyle,iSrc,iAlt,iWidth)
{
    write("<img ");
    if(typeof iStyle !== "undefined") write("style=\"" + iStyle + "\"");
    write("src=\"" + iSrc + "\"");
    write("alt=\"" + iAlt + "\"");
    if(typeof iWidth !== "undefine") write("width=\"" + iWidth + "\"");
    writeln("/>");
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

    writeln("<img src=\"" + imgSrc + "\" alt=\"Model image\" style=\"height:230px;\"/>");
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

function tableCell(tText,cStyle) //Table cell
{
    if(typeof cStyle === "undefined") write("<td>");
    else write("<td style=\"" + cStyle + "\">");
    writeln(tText + "</td>");
}

function writeCol(cSpan,cStyle)
{
    writeln("<col span=\"" + cSpan + "\" " + "style=\"" + cStyle + "\">");
}

function formatCycleTime(cycleTime) 
{
    cycleTime += 0.5; // round up
    var seconds = cycleTime % 60 | 0;
    var minutes = ((cycleTime - seconds) / 60 | 0) % 60;
    var hours = (cycleTime - minutes * 60 - seconds) / (60 * 60) | 0;
    if (hours > 0) {
      return subst(localize("%1h:%2m:%3s"), hours, minutes, seconds);
    } else if (minutes > 0) {
      return subst(localize("%1m:%2s"), minutes, seconds);
    } else {
      return subst(localize("%1s"), seconds);
    }
}

function formatWorkOfs(workOfs)
{
    //WCS starts at 1 -> G54, 2 -> G55 etc. 
    if(workOfs==0) workOfs+=1; //If set to default
    workOfs+=53;
    var workOfsStr="G" + workOfs;

    return workOfsStr;
}

function getJobTime()
{
    var totalJobTime=0;
    var totalRapidDist=0;
    var nSections=getNumberOfSections();

    for (var i=0; i < nSections; ++i)
    {
        var cSection=getSection(i);
        totalJobTime+=cSection.getCycleTime();
        totalRapidDist+=cSection.getRapidDistance();
    }
    totalJobTime += totalRapidDist / getProperty("rapidFeed") * 60;

    return totalJobTime;
}

function writeToolTable() //Write html tool table
{

}

function writePathTable() //Write html toolpath table
{

}

function onOpen() //On init of post
{
    htmlSetup();

    //WS logo
    var wsLogoPath = findFile("FablabLogoBW_Text.png");
    writeImg("padding-bottom:15px",getImageAsImgSrc(wsLogoPath),"WS Logo","40%");

    //Title
    if(getProperty("showTitleBlock"))
    {
        //Get date created
        var d = new Date();
        var currentDate=d.getDate() + "-0" + (d.getMonth()+1) + "-" + d.getFullYear();
        var mTime=getJobTime();

        tableS("topTable");
            writeln("<colgroup>");
                writeCol("2","background-color: #dddddd");
                writeCol("2","background-color: white");
                writeCol("1","background-color: #dddddd");
            writeln("</colgroup>");
            tableRowS();
                tableCell("Job name:");
                tableCell(getProperty("projName"));
                tableCell("Program No. :");
                tableCell(programName);
                tableCell("Machining time","text-align:center");
            tableRowE();
            tableRowS();
                tableCell("Date created:");
                tableCell(currentDate);
                tableCell("Comment:");
                tableCell(programComment);
                tableCell(formatCycleTime(mTime),"text-align:center");
            tableRowE();
        tableE();
    }
}

function onSection() //On start of section
{

}

function onSectionEnd() //On end of section
{
    if(isFirstSection())
    {
        var workpiece=getWorkpiece();
        var stockDim=Vector.diff(workpiece.upper, workpiece.lower);
        var lower = new Vector(getParameter("part-lower-x"), getParameter("part-lower-y"), getParameter("part-lower-z"));
        var upper = new Vector(getParameter("part-upper-x"), getParameter("part-upper-y"), getParameter("part-upper-z"));
        var partDim=Vector.diff(upper, lower);
        var cWorkOfs=currentSection.workOffset;

        //Setup info
        if(getProperty("showSetup"))
        {
            divS("contentContainer");
                divSE("contentHeader","SETUP");
                divS("setupInfoContainer");
                    divS("setupInfo");
                        divS("setupInfoMatHeadCont");
                            divSE("setupInfoMatHead","STOCK");
                            divSE("setupInfoMatHead","PART");
                        divE();

                        divS("setupInfoMatContCont");
                            divS("setupInfoMatCont");
                                divSE("setupInfoMatBlock","X: " + xyzFormat.format(stockDim.x));
                                divSE("setupInfoMatBlock","Y: " + xyzFormat.format(stockDim.y));
                                divSE("setupInfoMatBlock","Z: " + xyzFormat.format(stockDim.z));
                            divE();
                            divS("setupInfoMatCont");
                                divSE("setupInfoMatBlock","X: " + xyzFormat.format(partDim.x));
                                divSE("setupInfoMatBlock","Y: " + xyzFormat.format(partDim.y));
                                divSE("setupInfoMatBlock","Z: " + xyzFormat.format(partDim.z));
                            divE();
                        divE();

                        divS("setupInfoWCSCont");
                            divSE("setupInfoWCS","Work offset: " + formatWorkOfs(cWorkOfs));
                        divE();

                        divSE("setupInfoMatHead","SETUP NOTES");
                        divS("setupInfoNotes");
                            writeln("OP1 PRL38 <br/>");
                            writeln("OP1 PRL38 <br/>");
                            writeln("OP1 PRL38 <br/>");
                            writeln("OP1 PRL38 <br/>");
                        divE();
                    divE();
                    modelImg();
                divE();
            divE();
        }

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