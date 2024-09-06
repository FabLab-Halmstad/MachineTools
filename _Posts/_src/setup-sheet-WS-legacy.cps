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
 * writeToolsAll - BETA
 * Hightlight tools with the same T number
 * TOOL B - layout - show tools with feed and speed
 * Option for inverting image? That way it might be easier to view. 
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
    writeSetup:
    {
        title : "Show setup info",
        description : "Show setup information for OP",
        type : "boolean",
        value : true,
        scope : "post"
    },
    writeTools:
    {
        title : "Show tools",
        description : "Show list of tools for OP",
        type : "boolean",
        value : true,
        scope : "post"
    },
    writePaths:
    {
        title : "Show toolpaths",
        description : "Show list of toolpaths for OP",
        type : "boolean",
        value : true,
        scope : "post"
    },
    hideDuplicates:
    {
        title : "Hide duplicates",
        description : "Hide duplicated tools",
        type : "boolean",
        value : true,
        scope : "post"
    },
    hideMnc:
    {
        title : "Hide ManualNC",
        description : "Hide manual nc snippets",
        type : "boolean",
        value : false,
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

var wsLogoWebPath="https://raw.githubusercontent.com/FabLab-Halmstad/MachineTools/main/_Posts/_src/FablabLogoBW_Text.png";

var xyzFormat = createFormat({decimals:5, forceDecimal:true});
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

function tableRowS(rStyle) //Table row start
{
    write("<tr")

    if(typeof rStyle !== "undefined") write(" style=\"" + rStyle + "\"");

    writeln(">");
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

function formatSetupDim(data)
{
    var zPadding=2;
    var fData=xyzFormat.format(data); //Round off

    //Add trailing zeros
    var dec=(fData.length)-(fData.indexOf(".")+1)
    if(dec < zPadding) 
    {
        dec=zPadding-dec;
        for(var i=0; i < dec;++i) fData+="0";
    }

    return fData;
}

function getCoolantDescription(coolant) 
{
    switch (coolant) 
    {
        case COOLANT_OFF:
            return ("Off");
        case COOLANT_FLOOD:
            return ("Flood");
        case COOLANT_MIST:
            return ("Mist");
        case COOLANT_THROUGH_TOOL:
            return ("Through tool");
        case COOLANT_AIR:
            return ("Air");
        case COOLANT_AIR_THROUGH_TOOL:
            return ("Air through tool");
        case COOLANT_SUCTION:
            return ("Suction");
        case COOLANT_FLOOD_MIST:
            return ("Flood and mist");
        case COOLANT_FLOOD_THROUGH_TOOL:
            return ("Flood and through tool");
        default:
            return ("Unknown");
    }
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

function printNotes()
{
    //Check if op has notes
    if(hasParameter("job-notes"))
    {
        var opNotes=getParameter("job-notes");
        const splitOpNotes=opNotes.split("\n"); //Split on newline
        aLen=splitOpNotes.length;
        for(var i=0;i<aLen;++i) writeln(splitOpNotes[i] + "<br/>"); //Add line breaks

        return true;
    }
    else return false;
}

function writeToolTable() //Write html tool table - legacy
{
    divS("contentContainer","border:none;");
        divSE("contentHeader","TOOLS","border: 1px solid black; border-bottom:none;");
        tableS("toolTable");
            tableRowS();
                tableHead("Type");
                tableHead("T");
                tableHead("H");
                tableHead("Diameter");
                tableHead("NoF");
                tableHead("Desc.");
                tableHead("Cmt");
                tableHead("BL");
                tableHead("Vendor");
                tableHead("ID");
            tableRowE();
            var tools=getToolTable();
            for(var i=0;i<tools.getNumberOfTools();++i)
            {
                tableRowS();
                    var tool=tools.getTool(i);
                    tableCell(getToolTypeName(tool.type)); //1
                    tableCell("T" + tool.number);          //2
                    tableCell("H" + tool.lengthOffset);    //3
                    tableCell(tool.diameter);              //4
                    tableCell(tool.numberOfFlutes);        //5
                    tableCell(tool.description);           //6
                    tableCell(tool.comment);               //7
                    tableCell(tool.bodyLength);            //8
                    tableCell(tool.vendor);                //9
                    tableCell(tool.productId);             //10
                tableRowE();
            }
        tableE();
    divE();
}

function writeToolTableAll() //Write tool table, using getSection instead of getToolTable - BETA
{
    var nSection=getNumberOfSections();
    const sectIds=[]; //Section IDs
    const toolIds=[]; //Tool T numbers
    var valLeast=10; //Smallest value so far
    var valMost=1; //Biggest value so far

    //Sort by tool number
    for(var i=0;i<nSection;++i)
    {
        var sect=getSection(i);
        var tool=sect.getTool();

        if(tool.number <= valLeast) //Add to beginning
        {
            sectIds.unshift(sect.getId());
            toolIds.unshift(tool.number);
            valLeast=tool.number;
        }
        else if(tool.number >= valMost) //Add to end
        {
            sectIds.push(sect.getId());
            toolIds.push(tool.number);
            valMost=tool.number;
        }
        else //Add in between
        {
            for(var n=0;n<toolIds.length;++n)
            {
                if(tool.number < toolIds[n])
                {
                    toolIds.splice(n,0,tool.number);
                    sectIds.splice(n,0,sect.getId());
                    break;
                }
            }
        }
    }

    //Table header
    divS("contentContainer","border:none;");
        divSE("contentHeader","TOOLS","border: 1px solid black; border-bottom:none;");
        tableS("toolTable");
            tableRowS();
                tableHead("Type");
                tableHead("T");
                tableHead("H");
                tableHead("DIA");
                tableHead("NoF");
                tableHead("Desc.");
                tableHead("CMT");
                tableHead("BL");
                tableHead("Shaft");
                tableHead("Vendor");
                tableHead("ID");
            tableRowE();

    var lastTn;
    var lastHn;
    var lastDia;
    var lastBl;
    var lastDesc;

    //Write tools
    for(var i=0;i<sectIds.length;++i)
    {
        var sect=getSection(sectIds[i]);
        var tool=sect.getTool();

        var showTool=true;
        var toolOverlap=false; //Flag if two different tools have the same T number

        //Check for duplicates
        if(i!=0 && getProperty("hideDuplicates") && tool.number==lastTn) {
            if(tool.lengthOffset==lastHn) {
                if(tool.diameter==lastDia) {
                    if(tool.bodyLength==lastBl) {
                        if(tool.description==lastDesc) {
                            showTool=false; //Tool is likely to be a duplicate, don't show.
                        }
                    }
                }
            }
        }

        //Check for non-duplicate tools that have the same T number
        var overlapFlag="";
        if(i!=0 && showTool==true && tool.number==lastTn)
        {
            toolOverlap=true;
            overlapFlag="*";
        }
        
        if(showTool)
        {
            if(toolOverlap) tableRowS("background-color:rgb(254, 148, 148);");
            else tableRowS();
                tableCell(getToolTypeName(tool.type));      //1
                tableCell(overlapFlag + "T" + tool.number); //2
                tableCell("H" + tool.lengthOffset);         //3
                tableCell("&empty;" + tool.diameter);       //4
                tableCell(tool.numberOfFlutes);             //5
                tableCell(tool.description);                //6
                tableCell(tool.comment);                    //7
                tableCell(tool.bodyLength);                 //8
                tableCell("&empty;" + tool.shaftDiameter);  //9
                tableCell(tool.vendor);                     //10
                tableCell(tool.productId);                  //11
            tableRowE();

            lastTn=tool.number;
            lastHn=tool.lengthOffset;
            lastDia=tool.diameter;
            lastBl=tool.bodyLength;
            lastDesc=tool.description;
        }
    }

        tableE();
    divE();
}

function writePathTableHead() //Write html toolpath table
{
    divS("contentContainer","border:none;");
        divSE("contentHeader","TOOLPATHS","border: 1px solid black; border-bottom:none;");
        tableS("pathTable");
            tableRowS();
                tableHead("Strategy");
                tableHead("Tool");
                tableHead("Tool type");
                tableHead("Coolant");
                tableHead("Cycle time");
                tableHead("RPM");
                tableHead("Feedrate");
                tableHead("fz");
            tableRowE();
}

function htmlSetup()
{
    write(
    "<!DOCTYPE html> \n" +
    "<html> \n" +
    " <head> \n" +
    "<meta http-equiv=\"content-type\" content=\"text/html; charset=utf-8\"> \n" +
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
    //Generated by:
    var sysGen="";
    if(hasGlobalParameter("generated-by")) sysGen=getGlobalParameter("generated-by");
    else sysGen="Autodesk CAM";

            divE(); //Sub page
            divS("footerCont");
                divSE("camSysFooter","Generated by: " + sysGen);
            divE();
        divE(); //Main page
    writeln("</body>");
    writeln("</html>");
}

const cachedMncCMD=[];
const cachedMncVal=[];

function onManualNC(command, value)
{
    cachedMnc=true;

    switch (command)
    {
        case COMMAND_COMMENT:
            cachedMncCMD.push("CMT: ");
            cachedMncVal.push(value);
        break;
        case COMMAND_STOP:
            cachedMncCMD.push("Stop");
        break;
        case COMMAND_OPTIONAL_STOP:
            cachedMncCMD.push("Optional stop");
        break;
        case COMMAND_TOOL_MEASURE:
            cachedMncCMD.push("Tool measure");
        break;
        case COMMAND_CALIBRATE:
            cachedMncCMD.push("Calibrate");
        break;
        case COMMAND_VERIFY:
            cachedMncCMD.push("Verify");
        break;
        case COMMAND_CLEAN:
            cachedMncCMD.push("Clean");
        break;
        case COMMAND_ACTION:
            cachedMncCMD.push("A: ");
            cachedMncVal.push(value);
        break;
        case COMMAND_PRINT_MESSAGE:
            cachedMncCMD.push("P: ");
            cachedMncVal.push(value);
        break;
        case COMMAND_DISPLAY_MESSAGE:
            cachedMncCMD.push("PD: ");
            cachedMncVal.push(value);
        break;
        case COMMAND_ALARM:
            cachedMncCMD.push("Alarm");
        break;
        case COMMAND_ALERT:
            cachedMncCMD.push("Alert");
        break;
        case COMMAND_PASS_THROUGH:
            cachedMncCMD.push("PT: ");
            cachedMncVal.push(value);
        break;
    }
}

function onOpen() //On init of post
{
    htmlSetup();

    //WS logo
    writeImg("padding-bottom:15px",wsLogoWebPath,"WS Logo","40%");

    /*
    var wsLogoPath = findFile("_Custom/FablabLogoBW_Text.png");
    writeImg("padding-bottom:15px",getImageAsImgSrc(wsLogoPath),"WS Logo","40%");
    */

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
        if(getProperty("writeSetup"))
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
                                divSE("setupInfoMatBlock","X: " + formatSetupDim(stockDim.x));
                                divSE("setupInfoMatBlock","Y: " + formatSetupDim(stockDim.y));
                                divSE("setupInfoMatBlock","Z: " + formatSetupDim(stockDim.z));
                            divE();
                            divS("setupInfoMatCont");
                                divSE("setupInfoMatBlock","X: " + formatSetupDim(partDim.x));
                                divSE("setupInfoMatBlock","Y: " + formatSetupDim(partDim.y));
                                divSE("setupInfoMatBlock","Z: " + formatSetupDim(partDim.z));
                            divE();
                        divE();

                        divS("setupInfoWCSCont");
                            divSE("setupInfoWCS","Work offset: " + formatWorkOfs(cWorkOfs));
                        divE();

                        divSE("setupInfoMatHead","SETUP NOTES");
                        divS("setupInfoNotes");
                            writeln("All units are metric. <br/>");
                            printNotes(); //Print OP notes
                        divE();
                    divE();
                    modelImg(); //Display setup image
                divE();
            divE();
        }

        if(getProperty("writeTools")) writeToolTableAll(); //Write tools ALL
        if(getProperty("writePaths")) writePathTableHead(); //Write path table header
    }
    if(getProperty("writePaths"))
    {
        //Write Manual nc
        var mncCutof=16; //Cuts of the value after this many charecters
        if(cachedMncCMD.length && !getProperty("hideMnc"))
        {
            for(var i=0;i<cachedMncCMD.length;++i)
            {
                var textOut=cachedMncCMD[i];
                if(typeof cachedMncVal[i] !== "undefined") //Check whether there exist a value
                {
                    if(cachedMncVal[i].length > mncCutof) textOut+=cachedMncVal[i].substring(0,mncCutof-1) + "..."; //Cut of if too long
                    else textOut+=cachedMncVal[i];
                }

                tableRowS("border-right:1px solid black;");
                    tableCell(textOut);
                tableRowE();
            }
            //Data has been printed, delete all. 
            cachedMncCMD.length=0;
            cachedMncVal.length=0;
        }

        var pathId=currentSection.getId();
        var descr=getParameter("operation-strategy");
        var cmt=getParameter("operation-comment");
        var cTool=currentSection.getTool();
        var cycleT=currentSection.getCycleTime();
        var spindleSpd=currentSection.getMaximumSpindleSpeed();
        var maxFeedrate=currentSection.getMaximumFeedrate();
        var feedPerT=maxFeedrate/(spindleSpd*cTool.numberOfFlutes); //Feed per tooth calc

        tableRowS();
            tableCell(cmt);
            tableCell("T" + cTool.number);
            tableCell(getToolTypeName(cTool.type));
            tableCell(getCoolantDescription(cTool.coolant));
            tableCell(formatCycleTime(cycleT));
            tableCell(rpmFormat.format(spindleSpd));
            tableCell(feedFormat.format(maxFeedrate));
            tableCell(feedFormat.format(feedPerT));
        tableRowE();
    }
}

function onClose() //On close of post
{
    //Close up path table
    tableE();
    divE();

    htmlEnd();
}

function onTerminate()
{

}