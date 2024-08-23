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

function writeToolTable() //Write html tool table
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

function writeToolTableAll()
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
                tableHead("Diameter");
                tableHead("NoF");
                tableHead("Desc.");
                tableHead("Cmt");
                tableHead("BL");
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

        //Show all?
        if(i!=0 && tool.number==lastTn) {
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
        
        if(showTool)
        {
            tableRowS();
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
    "<style type=\"text/css\"> \n" +
    loadText("setup-sheet-templ-style.css","utf-8") + "\n" +
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
        divE(); //Main page
    writeln("</body>");
    writeln("</html>");
}

function onOpen() //On init of post
{
    htmlSetup();
}

function onSection() //On start of section
{

}

function onSectionEnd() //On end of section
{
    if(isFirstSection())
    {
        writeToolTableAll();
    }
}

function onClose() //On close of post
{
    htmlEnd();
}

function onTerminate()
{

}