/**
  Copyright (C) 2012-2020 by Autodesk, Inc.
  All rights reserved.

  HAAS post processor configuration.

  $Revision: 42663 468e89496622f958c58646dea9b42e01ed5532c0 $
  $Date: 2020-02-25 08:37:04 $
  
  FORKID {241E0993-8BE0-463b-8888-47968B9D7F9F}
*/

description = "HAAS (pre-NGC)";
vendor = "Haas Automation";
vendorUrl = "https://www.haascnc.com";
legal = "Copyright (C) 2012-2020 by Autodesk, Inc.";
certificationLevel = 2;
minimumRevision = 40783;

longDescription = "Generic post for use with all common 3-axis HAAS mills like the DM, VF, Office Mill, and Mini Mill series. This post is for the pre-Next Generation Control. By default positioning moves will be output as high feed G1s instead of G0s. You can turn on the property 'useG0' to force G0s but be careful as the CNC will follow a dogleg path rather than a direct path.";

extension = "txt";
programNameIsInteger = true;
setCodePage("ascii");

capabilities = CAPABILITY_MILLING;
tolerance = spatial(0.002, MM);

minimumChordLength = spatial(0.25, MM);
minimumCircularRadius = spatial(0.01, MM);
maximumCircularRadius = spatial(1000, MM);
minimumCircularSweep = toRad(0.01);
maximumCircularSweep = toRad(355);
allowHelicalMoves = true;
allowedCircularPlanes = undefined; // allow any circular motion
allowSpiralMoves = true;
highFeedrate = (unit == IN) ? 500 : 5000;

// user-defined properties
properties = {
  writeMachine: true, // write machine
  writeTools: true, // writes the tools
  writeVersion: false, // include version info
  preloadTool: true, // preloads next tool on tool change if any
  chipTransport: false, // turn on chip transport at start of program
  showSequenceNumbers: true, // show sequence numbers
  sequenceNumberStart: 10, // first sequence number
  sequenceNumberIncrement: 5, // increment for sequence numbers
  sequenceNumberOnlyOnToolChange: false, // only output sequence numbers on tool change
  optionalStop: true, // optional stop
  separateWordsWithSpace: true, // specifies that the words should be separated with a white space
  useRadius: false, // specifies that arcs should be output using the radius (R word) instead of the I, J, and K words.
  useParametricFeed: false, // specifies that feed should be output using Q values
  showNotes: false, // specifies that operation notes should be output
  useG0: false, // allow G0 when moving along more than one axis
  useG28: false, // specifies that G28 should be used instead of G53
  useSubroutines: false, // specifies that subroutines should be generated
  useSubroutinePatterns: false, // generates subroutines for patterned operation
  useSubroutineCycles: false, // generates subroutines for cycle operations on same holes
  useG187: false, // use G187 to set smoothing on the machine
  homePositionCenter: true, // moves the part in X in center of the door at end of program (ONLY WORKS IF THE TABLE IS MOVING)
  optionallyCycleToolsAtStart: false, // cycle through each tool used at the beginning of the program when block delete is turned off - this allows the operator to easily measure all tools before they are used for the first run of the program
  optionallyMeasureToolsAtStart: false, // measure each tool used at the beginning of the program when block delete is turned off - this allows the operator to easily measure all tools before they are used for the first run of the program
  toolBreakageTolerance: 0.1, // value for which tool break detection will raise an alarm
  safeStartAllOperations: false, // write optional blocks at the beginning of all operations that include all commands to start program
  fastToolChange: false, // skip spindle off, coolant off, and Z retract to make tool change quicker
  useG95forTapping: false, // use IPR/MPR instead of IPM/MPM for tapping
  useG73Retract: false, // use G73 Q K format for accumulated depth support
  setting34: 1.0, // diameter used by control to calculate feed rates (INCH value)
  useDPMFeeds: false, // output DPM feeds instead of Inverse Time feeds
  measSeqToolDiaLimit: 9 // Tool diameter limit before it is considered a big tool for auto measure sequence
};

propertyDefinitions = {
  writeMachine: {title:"Write machine", description:"Output the machine settings in the header of the code.", group:0, type:"boolean"},
  writeTools: {title:"Write tool list", description:"Output a tool list in the header of the code.", group:0, type:"boolean"},
  writeVersion: {title:"Write version", description:"Write the version number in the header of the code.", group:0, type:"boolean"},
  preloadTool: {title:"Preload tool", description:"Preloads the next tool at a tool change (if any).", type:"boolean"},
  chipTransport: {title:"Use chip transport", description:"Enable to turn on chip transport at start of program.", type:"boolean"},
  showSequenceNumbers: {title:"Use sequence numbers", description:"Use sequence numbers for each block of outputted code.", group:1, type:"boolean"},
  sequenceNumberStart: {title:"Start sequence number", description:"The number at which to start the sequence numbers.", group:1, type:"integer"},
  sequenceNumberIncrement: {title:"Sequence number increment", description:"The amount by which the sequence number is incremented by in each block.", group:1, type:"integer"},
  sequenceNumberOnlyOnToolChange: {title:"Block number only on tool change", description:"Specifies that block numbers should only be output at tool changes.", type:"boolean"},
  optionalStop: {title:"Optional stop", description:"Specifies that optional stops M1 should be output at tool changes.", type:"boolean"},
  separateWordsWithSpace: {title:"Separate words with space", description:"Adds spaces between words if 'yes' is selected.", type:"boolean"},
  useRadius: {title:"Radius arcs", description:"If yes is selected, arcs are output using radius values rather than IJK.", type:"boolean"},
  useParametricFeed:  {title:"Parametric feed", description:"Parametric feed values based on movement type are output.", type:"boolean"},
  showNotes: {title:"Show notes", description:"Enable to output notes for operations.", type:"boolean"},
  useG0: {title:"Use G0", description:"Specifies that G0s should be used for rapid moves when moving along a single axis.", type:"boolean"},
  useG28: {title:"Use G28 instead of G53", description:"Specifies that machine retracts should be done using G28 instead of G53.", type:"boolean"},
  useSubroutines: {title:"Use subroutines", description:"Enables output of subroutines for each operation.", type:"boolean"},
  useSubroutinePatterns: {title:"Subroutines for patterns", description:"Enable output of subroutines for patterns.", type:"boolean"},
  useSubroutineCycles: {title:"Subroutines for cycles", description:"Enable output of subroutines for cycles.", type:"boolean"},
  useG187: {title:"Use G187", description:"Specifies that smoothing using G187 should be used.", type:"boolean"},
  homePositionCenter: {title:"Home position center", description:"Enable to center the part along X at the end of program for easy access. Requires a CNC with a moving table.", type:"boolean"},
  optionallyCycleToolsAtStart: {title:"Optionally cycle tools at start", description:"Cycle through each tool used at the beginning of the program when block delete is turned off.", type:"boolean"},
  optionallyMeasureToolsAtStart: {title:"Optionally measure tools at start", description:"Measure each tool used at the beginning of the program when block delete is turned off.", type:"boolean"},
  toolBreakageTolerance: {title:"Tool breakage tolerance", description:"Specifies the tolerance for which tool break detection will raise an alarm.", type:"spatial"},
  safeStartAllOperations: {title:"Safe start all operations", description:"Write optional blocks at the beginning of all operations that include all commands to start program.", type:"boolean"},
  fastToolChange: {title:"Fast tool change", description:"Skip spindle off, coolant off, and Z retract to make tool change quicker.", type:"boolean"},
  useG95forTapping: {title:"Use G95 for tapping", description:"use IPR/MPR instead of IPM/MPM for tapping", type:"boolean"},
  useG73Retract: {title:"G73 cycles include accumulated depth", description:"Use G73 Q K format for accumulated depth support.", type:"boolean"},
  setting34: {title:"Feed rate calculation diameter", description:"Defines the part diameter in inches that the control uses to calculate feed rates (Setting 34).", type:"spatial", range:[0.1, 9999.0]},
  useDPMFeeds: {title:"Rotary moves use IPM feeds", description:"Enable to output IPM feeds, disable for Inverse Time feeds with rotary axes moves.", type:"boolean"},
  measSeqToolDiaLimit: {title:"Meas seq Tool Diameter Limit", description:"Tool diameter limit before it is considered a big tool for auto measure sequence", type:"integer"}
};

var singleLineCoolant = false; // specifies to output multiple coolant codes in one line rather than in separate lines
// samples:
// {id: COOLANT_THROUGH_TOOL, on: 88, off: 89}
// {id: COOLANT_THROUGH_TOOL, on: [8, 88], off: [9, 89]}
var coolants = [
  {id: COOLANT_FLOOD, on: 8},
  {id: COOLANT_MIST},
  {id: COOLANT_THROUGH_TOOL, on: 88, off: 89},
  {id: COOLANT_AIR, on: 83, off: 84},
  {id: COOLANT_AIR_THROUGH_TOOL, on: 73, off: 74},
  {id: COOLANT_SUCTION},
  {id: COOLANT_FLOOD_MIST},
  {id: COOLANT_FLOOD_THROUGH_TOOL, on: [88, 8], off: [89, 9]},
  {id: COOLANT_OFF, off: 9}
];

// old machines only support 4 digits
var oFormat = createFormat({width:5, zeropad:true, decimals:0});
var nFormat = createFormat({decimals:0});

var gFormat = createFormat({prefix:"G", decimals:0});
var mFormat = createFormat({prefix:"M", decimals:0});
var hFormat = createFormat({prefix:"H", decimals:0});
var dFormat = createFormat({prefix:"D", decimals:0});
var probe154Format = createFormat({decimals:0, zeropad:true, width:2});

var xyzFormat = createFormat({decimals:(unit == MM ? 3 : 4), forceDecimal:true});
var rFormat = xyzFormat; // radius
var abcFormat = createFormat({decimals:3, forceDecimal:true, scale:DEG});
var feedFormat = createFormat({decimals:(unit == MM ? 2 : 3), forceDecimal:true});
var pitchFormat = createFormat({decimals:(unit == MM ? 3 : 4), forceDecimal:true});
var toolFormat = createFormat({decimals:0});
var rpmFormat = createFormat({decimals:0});
var secFormat = createFormat({decimals:3, forceDecimal:true}); // seconds - range 0.001-1000
var milliFormat = createFormat({decimals:0}); // milliseconds // range 1-9999
var taperFormat = createFormat({decimals:1, scale:DEG});

var xOutput = createVariable({prefix:"X"}, xyzFormat);
var yOutput = createVariable({prefix:"Y"}, xyzFormat);
var zOutput = createVariable({onchange: function() {retracted = false;}, prefix:"Z"}, xyzFormat);
var aOutput = createVariable({prefix:"A"}, abcFormat);
var bOutput = createVariable({prefix:"B"}, abcFormat);
var cOutput = createVariable({prefix:"C"}, abcFormat);
var feedOutput = createVariable({prefix:"F"}, feedFormat);
var pitchOutput = createVariable({prefix:"F", force:true}, pitchFormat);
var sOutput = createVariable({prefix:"S", force:true}, rpmFormat);
var dOutput = createVariable({}, dFormat);

// circular output
var iOutput = createReferenceVariable({prefix:"I", force:true}, xyzFormat);
var jOutput = createReferenceVariable({prefix:"J", force:true}, xyzFormat);
var kOutput = createReferenceVariable({prefix:"K", force:true}, xyzFormat);

var gMotionModal = createModal({}, gFormat); // modal group 1 // G0-G3, ...
var gPlaneModal = createModal({onchange:function () {gMotionModal.reset();}}, gFormat); // modal group 2 // G17-19
var gAbsIncModal = createModal({}, gFormat); // modal group 3 // G90-91
var gFeedModeModal = createModal({}, gFormat); // modal group 5 // G93-94
var gUnitModal = createModal({}, gFormat); // modal group 6 // G20-21
var gCycleModal = createModal({}, gFormat); // modal group 9 // G81, ...
var gRetractModal = createModal({force:true}, gFormat); // modal group 10 // G98-99
var gRotationModal = createModal({}, gFormat); // modal group 16 // G68-G69

// fixed settings
var firstFeedParameter = 100; // the first variable to use with parametric feed
var forceResetWorkPlane = false; // enable to force reset of machine ABC on new orientation
var minimumCyclePoints = 5; // minimum number of points in cycle operation to consider for subprogram

var WARNING_WORK_OFFSET = 0;

var ANGLE_PROBE_NOT_SUPPORTED = 0;
var ANGLE_PROBE_USE_ROTATION = 1;
var ANGLE_PROBE_USE_CAXIS = 2;

var SUB_UNKNOWN = 0;
var SUB_PATTERN = 1;
var SUB_CYCLE = 2;

// collected state
var sequenceNumber;
var currentWorkOffset;
var optionalSection = false;
var forceSpindleSpeed = false;
var activeMovements; // do not use by default
var currentFeedId;
var maximumCircularRadiiDifference = toPreciseUnit(0.005, MM);
var maximumLineLength = 80; // the maximum number of charaters allowed in a line
var g68RotationMode = 0;
var angularProbingMode;
var subprograms = [];
var currentPattern = -1;
var firstPattern = false;
var currentSubprogram;
var lastSubprogram;
var initialSubprogramNumber = 90000;
var definedPatterns = new Array();
var incrementalMode = false;
var saveShowSequenceNumbers;
var cycleSubprogramIsActive = false;
var patternIsActive = false;
var lastOperationComment = "";
var incrementalSubprogram;
var retracted = false; // specifies that the tool has been retracted to the safe plane
var measureTool = false;
probeMultipleFeatures = true;

// used to convert blocks to optional for safeStartAllOperations, might get used outside of onSection
var operationNeedsSafeStart = false;

/**
  Writes the specified block.
*/
var skipBlock = false;
function writeBlock() {
  var text = formatWords(arguments);
  if (!text) {
    return;
  }
  var maximumSequenceNumber = (properties.useSubroutines || properties.useSubroutinePatterns ||
    properties.useSubroutineCycles) ? initialSubprogramNumber : 99999;
  if (properties.showSequenceNumbers) {
    if (sequenceNumber >= maximumSequenceNumber) {
      sequenceNumber = properties.sequenceNumberStart;
    }
    if (optionalSection || skipBlock) {
      if (text) {
        writeWords("/", "N" + sequenceNumber, text);
      }
    } else {
      writeWords2("N" + sequenceNumber, arguments);
    }
    sequenceNumber += properties.sequenceNumberIncrement;
  } else {
    if (optionalSection || skipBlock) {
      writeWords2("/", arguments);
    } else {
      writeWords(arguments);
    }
  }
  skipBlock = false;
}

/**
  Writes the specified block - used for tool changes only.
*/
function writeToolBlock() {
  var show = properties.showSequenceNumbers;
  properties.showSequenceNumbers = show || properties.sequenceNumberOnlyOnToolChange;
  writeBlock(arguments);
  properties.showSequenceNumbers = show;
}

/**
  Writes the specified optional block.
*/
function writeOptionalBlock() {
  skipBlock = true;
  writeBlock(arguments);
}

function formatComment(text) {
  return "(" + String(text).replace(/[()]/g, "") + ")";
}

/**
  Output a comment.
*/
function writeComment(text) {
  writeln(formatComment(text.substr(0, maximumLineLength - 2)));
}

function onOpen() {
    if (properties.useRadius) {
      maximumCircularSweep = toRad(90); // avoid potential center calculation errors for CNC
    }
    if (properties.sequenceNumberOnlyOnToolChange) {
      properties.showSequenceNumbers = false;
    }
  
    gRotationModal.format(69); // Default to G69 Rotation Off
  
    if (false) { // note: setup your machine here
      var aAxis = createAxis({coordinate:0, table:true, axis:[-1, 0, 0], range:[-30 - 0.0001, 120 + 0.0001], preference:1});
      var bAxis = createAxis({coordinate:1, table:true, axis:[0, 0, 1], range:[-999.999, 999.999]});
      machineConfiguration = new MachineConfiguration(aAxis, bAxis);
  
      setMachineConfiguration(machineConfiguration);
      optimizeMachineAngles2(1); // map tip mode
    }
  
    if (!machineConfiguration.isMachineCoordinate(0)) {
      aOutput.disable();
    }
    if (!machineConfiguration.isMachineCoordinate(1)) {
      bOutput.disable();
    }
    if (!machineConfiguration.isMachineCoordinate(2)) {
      cOutput.disable();
    }
  
    if (highFeedrate <= 0) {
      error(localize("You must set 'highFeedrate' because axes are not synchronized for rapid traversal."));
      return;
    }
    
    if (!properties.separateWordsWithSpace) {
      setWordSeparator("");
    }
  
    sequenceNumber = properties.sequenceNumberStart;
    writeln("%");
  
    if (programName) {
      var programId;
      try {
        programId = getAsInt(programName);
      } catch (e) {
        error(localize("Program name must be a number."));
        return;
      }
      if (!((programId >= 1) && (programId <= 99999))) {
        error(localize("Program number is out of range."));
        return;
      }
      writeln(
        "O" + oFormat.format(programId) +
        conditional(programComment, " " + formatComment(programComment.substr(0, maximumLineLength - 2 - ("O" + oFormat.format(programId)).length - 1)))
      );
      lastSubprogram = (initialSubprogramNumber - 1);
    } else {
      error(localize("Program name has not been specified."));
      return;
    }
    
    if (properties.useG0) {
      writeComment(localize("Using G0 which travels along dogleg path."));
    } else {
      writeComment(subst(localize("Using high feed G1 F%1 instead of G0."), feedFormat.format(highFeedrate)));
    }
  
    if (properties.writeVersion) {
      if ((typeof getHeaderVersion == "function") && getHeaderVersion()) {
        writeComment(localize("post version") + ": " + getHeaderVersion());
      }
      if ((typeof getHeaderDate == "function") && getHeaderDate()) {
        writeComment(localize("post modified") + ": " + getHeaderDate());
      }
    }
  
    // dump machine configuration
    var vendor = machineConfiguration.getVendor();
    var model = machineConfiguration.getModel();
    var description = machineConfiguration.getDescription();
  
    if (properties.writeMachine && (vendor || model || description)) {
      writeComment(localize("Machine"));
      if (vendor) {
        writeComment("  " + localize("vendor") + ": " + vendor);
      }
      if (model) {
        writeComment("  " + localize("model") + ": " + model);
      }
      if (description) {
        writeComment("  " + localize("description") + ": "  + description);
      }
    }
  
    // dump tool information
    if (properties.writeTools) {
      var zRanges = {};
      if (is3D()) {
        var numberOfSections = getNumberOfSections();
        for (var i = 0; i < numberOfSections; ++i) {
          var section = getSection(i);
          var zRange = section.getGlobalZRange();
          var tool = section.getTool();
          if (zRanges[tool.number]) {
            zRanges[tool.number].expandToRange(zRange);
          } else {
            zRanges[tool.number] = zRange;
          }
        }
      }
  
      var tools = getToolTable();
      if (tools.getNumberOfTools() > 0) {
        for (var i = 0; i < tools.getNumberOfTools(); ++i) {
          var tool = tools.getTool(i);
          var comment = "T" + toolFormat.format(tool.number) + " " +
            "H" + toolFormat.format(tool.lengthOffset) + " " +
            "D=" + xyzFormat.format(tool.diameter) + " " +
            localize("CR") + "=" + xyzFormat.format(tool.cornerRadius);
          if ((tool.taperAngle > 0) && (tool.taperAngle < Math.PI)) {
            comment += " " + localize("TAPER") + "=" + taperFormat.format(tool.taperAngle) + localize("deg");
          }
          if (zRanges[tool.number]) {
            comment += " - " + localize("ZMIN") + "=" + xyzFormat.format(zRanges[tool.number].getMinimum());
          }
          comment += " - " + getToolTypeName(tool.type);
          writeComment(comment);
        }
      }
    }
  
    // optionally cycle through all tools
    if (properties.optionallyCycleToolsAtStart || properties.optionallyMeasureToolsAtStart) {
      var tools = getToolTable();
      if (tools.getNumberOfTools() > 0) {
        writeln("");
  
        writeOptionalBlock(mFormat.format(0), formatComment(localize("Read note"))); // wait for operator
        writeComment(localize("With BLOCK DELETE turned off each tool will cycle through"));
        writeComment(localize("the spindle to verify that the correct tool is in the tool magazine"));
        if (properties.optionallyMeasureToolsAtStart) {
          writeComment(localize("and to automatically measure it"));
        }
        writeComment(localize("Once the tools are verified turn BLOCK DELETE on to skip verification"));
        
        for (var i = 0; i < tools.getNumberOfTools(); ++i) {
          var tool = tools.getTool(i);
          if (properties.optionallyMeasureToolsAtStart && (tool.type == TOOL_PROBE)) {
            continue;
          }
          var comment = "T" + toolFormat.format(tool.number) + " " +
            "D=" + xyzFormat.format(tool.diameter) + " " +
            localize("CR") + "=" + xyzFormat.format(tool.cornerRadius);
          if ((tool.taperAngle > 0) && (tool.taperAngle < Math.PI)) {
            comment += " " + localize("TAPER") + "=" + taperFormat.format(tool.taperAngle) + localize("deg");
          }
          comment += " - " + getToolTypeName(tool.type);
          writeComment(comment);
          if (properties.optionallyMeasureToolsAtStart) {
            writeToolMeasureBlock(tool);
          } else {
            writeToolCycleBlock(tool);
          }
        }
      }
      writeln("");
    }
  
    if (false /*properties.useDynamicWorkOffset*/) {
      var failed = false;
      var dynamicWCSs = {};
      for (var i = 0; i < getNumberOfSections(); ++i) {
        var section = getSection(i);
        var description = section.hasParameter("operation-comment") ? section.getParameter("operation-comment") : ("#" + (i + 1));
        if (!section.hasDynamicWorkOffset()) {
          error(subst(localize("Dynamic work offset has not been set for operation '%1'."), description));
          failed = true;
        }
        
        var o = section.getDynamicWCSOrigin();
        var p = section.getDynamicWCSPlane();
        if (dynamicWCSs[section.getDynamicWorkOffset()]) {
          if ((Vector.diff(o, dynamicWCSs[section.getDynamicWorkOffset()].origin).length > 1e-9) ||
              (Matrix.diff(p, dynamicWCSs[section.getDynamicWorkOffset()].plane).n1 > 1e-9)) {
            error(subst(localize("Dynamic WCS mismatch for operation '%1'."), description));
            failed = true;
          }
        } else {
          dynamicWCSs[section.getDynamicWorkOffset()] = {origin:o, plane:p};
        }
      }
      if (failed) {
        return;
      }
    }
  
    if (false) {
      // check for duplicate tool number
      for (var i = 0; i < getNumberOfSections(); ++i) {
        var sectioni = getSection(i);
        var tooli = sectioni.getTool();
        for (var j = i + 1; j < getNumberOfSections(); ++j) {
          var sectionj = getSection(j);
          var toolj = sectionj.getTool();
          if (tooli.number == toolj.number) {
            if (xyzFormat.areDifferent(tooli.diameter, toolj.diameter) ||
                xyzFormat.areDifferent(tooli.cornerRadius, toolj.cornerRadius) ||
                abcFormat.areDifferent(tooli.taperAngle, toolj.taperAngle) ||
                (tooli.numberOfFlutes != toolj.numberOfFlutes)) {
              error(
                subst(
                  localize("Using the same tool number for different cutter geometry for operation '%1' and '%2'."),
                  sectioni.hasParameter("operation-comment") ? sectioni.getParameter("operation-comment") : ("#" + (i + 1)),
                  sectionj.hasParameter("operation-comment") ? sectionj.getParameter("operation-comment") : ("#" + (j + 1))
                )
              );
              return;
            }
          }
        }
      }
    }
  
    if ((getNumberOfSections() > 0) && (getSection(0).workOffset == 0)) {
      for (var i = 0; i < getNumberOfSections(); ++i) {
        if (getSection(i).workOffset > 0) {
          error(localize("Using multiple work offsets is not possible if the initial work offset is 0."));
          return;
        }
      }
    }
  
    // absolute coordinates and feed per min
    writeBlock(gAbsIncModal.format(90), gFeedModeModal.format(94), gPlaneModal.format(17));
  
    switch (unit) {
    case IN:
      writeBlock(gUnitModal.format(20));
      break;
    case MM:
      writeBlock(gUnitModal.format(21));
      break;
    }
  
    if (properties.chipTransport) {
      onCommand(COMMAND_START_CHIP_TRANSPORT);
    }
    // Probing Surface Inspection
    if (typeof inspectionWriteVariables == "function") {
      inspectionWriteVariables();
    }
  }

  function onComment(message) {
    writeComment(message);
  }
  
  /*
  Supported:
    -Comment
    -Stop
    -Opt stop
    -Dwell
    -Measure tool -> Pause for manual tool measure
    -Calibrate
    -Verify
    -Clean -> Pause for cleaning -> Fan auto?
    -Action -> PROBE -> Auto meas tool
    -Print -> Print msg
    -Display -> Display msg
    -Alarm -> Stop with alarm
    -Alert -> Non stop with alert
    -Pass through
    -Call program
  
  */
  
  const toolMeasTag=["MEAS_1","MEAS_2","MEAS_3","MEAS_4","MEAS_5","MEAS_6","MEAS_7","MEAS_8","MEAS_9","MEAS_10","MEAS_ALL"];
  
  function manualToolMeas(toolNum)
  {
    var toolH=0;
    var toolD=0;
    var toolBL=0;
    var tools=getToolTable();
    var largeTool=false;
    var largeToolOfs=0;
  
    for(var i=0;i < tools.getNumberOfTools(); ++i)
    {
      var tool=tools.getTool(i);
      if(tool.number==toolNum) 
      {
        toolH=tool.lengthOffset;
        toolD=tool.diameter;
        toolBL=tool.bodyLength;
  
        if(tool.diameter > properties.measSeqToolDiaLimit) 
        {
          if(tool.type != TOOL_DRILL && 
             tool.type != TOOL_DRILL_CENTER &&
             tool.type != TOOL_DRILL_SPOT &&
             tool.type != TOOL_COUNTER_BORE &&
             tool.type != TOOL_COUNTER_SINK &&
             tool.type != TOOL_MILLING_END_BALL &&
             tool.type != TOOL_MILLING_END_BULLNOSE &&
             tool.type != TOOL_MILLING_LOLLIPOP &&
             tool.type != TOOL_MILLING_TAPERED && 
             tool.type != TOOL_PROBE &&
             tool.type != TOOL_MILLING_FORM)
            {
              largeTool=true;
              largeToolOfs=tool.diameter/2;
            }
        }
  
        break;
      }
    }
  
    writeComment("T" + toolNum + " " + "H" + toolH + " Meas seq.");
    writeComment("Block delete to skip - Press RESET to abort");
    writeComment("Diameter: " + toolD + "mm -" + " Body length: " + toolBL + "mm");
  
    writeOptionalBlock("T"+ toolNum +" M06");
  
    //writeOptionalBlock("M109 P501 (T" + toolNum + " " + "H" + toolH + " Meas)"); //Display msg
    writeBlock("M01"); //Optional stop
  
    //Setup
    writeOptionalBlock("G43 H" + toolH);
    writeOptionalBlock("G90");
    writeOptionalBlock("G00 G53 Z0.0");
    if(largeTool) writeOptionalBlock("G59 G00 X" + xyzFormat.format(largeToolOfs) + " Y0.0");
    else writeOptionalBlock("G59 G00 X0.0 Y0.0");
  
    //Plunging to measuring puck
    writeOptionalBlock("G59 G01 Z70.0 F3000.0");
    writeOptionalBlock("G59 G01 Z20.0 F500.0");
    writeComment("Measure tool please!");
    writeComment("H offset: " + toolH);
    writeOptionalBlock("M00");
    //TODO G10?
  
    //Return
    writeOptionalBlock("G53 G00 Z0.0");
  }
  
  function manualToolMeasAll()
  {
    writeComment("Manual tool measure - ALL");
  
    var tools=getToolTable();
  
    for(var i=0;i < tools.getNumberOfTools(); ++i)
    {
      var tool=tools.getTool(i);
      manualToolMeas(tool.number);
    }
  }
  
  function engraveText(xVal, yVal, zVal, chrHeight, textValue, tNum, hNum, cutFeed)
  {
    tNum=10;
    hNum=20;
    cutFeed=300; 
    var xPos=Number(xVal);
    var yPos=Number(yVal);
    var zDepth=Number(zVal);
    var cH=Number(chrHeight);
  
    //Setup
    writeComment("Engrave NC START!");
  
    writeBlock("T"+tNum+" M06");
    writeBlock("G43 H"+hNum);
    writeBlock("M03 S10000");
    writeBlock("M08");
    writeBlock("G90 G53 G00 Z0.0");
    writeBlock("G54 G00 "+ "X" + xyzFormat.format(xPos) + " " + "Y" + xyzFormat.format(yPos));
    writeBlock("G54 G01 Z20.0 F1500.0");
  
    writeBlock("G17 G90");
    writeBlock("G47 P0 " + "X" + xyzFormat.format(xPos) + " " + "Y" + xyzFormat.format(yPos) + " I0 J" + xyzFormat.format(cH) + " R2.0 " + "Z" + zDepth + " E100.0 F" + xyzFormat.format(cutFeed) + " " + "(" + textValue + ")");
    
    writeBlock("G90 G53 G00 Z0.0");
  
    writeBlock("M01");
    writeComment("Engrave NC END!")
  }
  
  /* TODO : finish!
  function engraveTextMLine(xVal, yVal, zVal, chrHeight, engraveText, tNum, hNum, cutFeed)
  {
    tNum=10;
    hNum=20;
    cutFeed=300; 
    var xPos=Number(xVal);
    var yPos=Number(yVal);
    var zDepth=Number(zVal);
    var cH=Number(chrHeight);
    
    writeComment("M-NC MLine Engrave:");
    for(let i=0; i<= (engraveText.length)-1; i++) writeComment(engraveText[i]);
  
    for(let i=0; i<= (engraveText.length)-1; i++)
    {
      writeBlock("G47 P0 " + "X" + xyzFormat.format(xPos) + " " + "Y" + xyzFormat.format(yPos) + " I0 J" + xyzFormat.format(cH) + " R2.0 " + "Z" + zDepth + " E100.0 F" + xyzFormat.format(cutFeed) + " " + "(" + engraveText[i] + ")"); 
    }
  }
  */
  
  function onManualNC(command, value) {
    switch (command) {
    case COMMAND_COMMENT: //Write comment to gcode
        writeComment(value);
      break;
    case COMMAND_STOP:
        writeBlock("M00");
      break;
    case COMMAND_OPTIONAL_STOP:
        writeBlock("M01");
      break;
    case COMMAND_TOOL_MEASURE: //Measure current tool
        writeComment("Measure current tool");
      break;
    case COMMAND_CALIBRATE:
      writeComment("Calibrate!");
    break;
    case COMMAND_VERIFY: //Verify the work area, tool breakage etc. 
        writeComment("Verify");
      break;
    case COMMAND_CLEAN: //Clean the work area
        writeComment("Clean");
      break;
    case COMMAND_ACTION: //Action, use tag to select which
      //Tag MEAS
      for(var i=0;i <= 9;++i)
      {
        if(value==toolMeasTag[i]) manualToolMeas(i+1);
      }
      if(value==toolMeasTag[10]) manualToolMeasAll();
  
      //Tag ENGR
      var cmd=String(value).split("_");
      if(cmd[0]=="ENGR")
      {
        //ENGR_5,5,-0.1,4,text!
        val=String(cmd[1]).split(",");
        engraveText(val[0],val[1],val[2],val[3],val[4]);
      }
  
      /* TODO : finish!
      //Tag ENGRM
      var cmd=String(value).split("_");
      if(cmd[0]=="ENGRM")
      {
        //ENGRM_5,5,-0.3,4,text1,text2,text3
        var param=String(cmd[1]).split(",");
        var inText=[];
        for(let i=0; param[4+i]!=null; i++)
        {
          inText.push(param[4+i]);
        }
        engraveTextMLine(param[0],param[1],param[2],param[3],inText);
      }
      */
  
      break;
    case COMMAND_PRINT_MESSAGE:
        writeComment(value);
      break;
    case COMMAND_DISPLAY_MESSAGE:
      writeComment(value);
    break;
    case COMMAND_ALARM:
      writeComment("Alarm");
    break;
    case COMMAND_ALERT:
        writeComment("Alert!");
      break;
    case COMMAND_PASS_THROUGH:
      var commands = String(value).split(",");
      for (value in commands) 
      {
        writeBlock(commands[value]);
      }
      break;
    }
  }

var currentWorkPlaneABC = undefined;

function forceWorkPlane() {
  currentWorkPlaneABC = undefined;
}

var currentCoolantMode = COOLANT_OFF;
var coolantOff = undefined;
var isOptionalCoolant = false;

  function setCoolant(coolant) {
    var coolantCodes = getCoolantCodes(coolant);
    if (Array.isArray(coolantCodes)) {
      if (singleLineCoolant) {
        skipBlock = isOptionalCoolant;
        writeBlock(coolantCodes.join(getWordSeparator()));
      } else {
        for (var c in coolantCodes) {
          skipBlock = isOptionalCoolant;
          writeBlock(coolantCodes[c]);
        }
      }
      return undefined;
    }
    return coolantCodes;
  }

  function setWorkPlane(abc) {
    if (!machineConfiguration.isMultiAxisConfiguration()) {
      return; // ignore
    }
  
    var _skipBlock = false;
    if (!((currentWorkPlaneABC == undefined) ||
          abcFormat.areDifferent(abc.x, currentWorkPlaneABC.x) ||
          abcFormat.areDifferent(abc.y, currentWorkPlaneABC.y) ||
          abcFormat.areDifferent(abc.z, currentWorkPlaneABC.z))) {
      if (operationNeedsSafeStart) {
        _skipBlock = true;
      } else {
        return; // no change
      }
    }
    
    skipBlock = _skipBlock;
    onCommand(COMMAND_UNLOCK_MULTI_AXIS);
  
    gMotionModal.reset();
    skipBlock = _skipBlock;
    writeBlock(
      gMotionModal.format(0),
      conditional(machineConfiguration.isMachineCoordinate(0), "A" + abcFormat.format(abc.x)),
      conditional(machineConfiguration.isMachineCoordinate(1), "B" + abcFormat.format(abc.y)),
      conditional(machineConfiguration.isMachineCoordinate(2), "C" + abcFormat.format(abc.z))
    );
    
    skipBlock = _skipBlock;
    onCommand(COMMAND_LOCK_MULTI_AXIS);
  
    currentWorkPlaneABC = abc;
  }

  function getCoolantCodes(coolant) {
    isOptionalCoolant = false;
    var multipleCoolantBlocks = new Array(); // create a formatted array to be passed into the outputted line
    if (!coolants) {
      error(localize("Coolants have not been defined."));
    }
    if (isProbeOperation()) { // avoid coolant output for probing
      coolant = COOLANT_OFF;
    }
    if (coolant == currentCoolantMode) {
      if (operationNeedsSafeStart && coolant != COOLANT_OFF && !isSpecialCoolantActive) {
        isOptionalCoolant = true;
      } else {
        return undefined; // coolant is already active
      }
    }
    if ((coolant != COOLANT_OFF) && (currentCoolantMode != COOLANT_OFF) && !isOptionalCoolant) {
      if (Array.isArray(coolantOff)) {
        for (var i in coolantOff) {
          multipleCoolantBlocks.push(mFormat.format(coolantOff[i]));
        }
      } else {
        multipleCoolantBlocks.push(mFormat.format(coolantOff));
      }
    }
  
    if (isSpecialCoolantActive) {
      forceSpindleSpeed = true;
    }
    var m;
    var coolantCodes = {};
    for (var c in coolants) { // find required coolant codes into the coolants array
      if (coolants[c].id == coolant) {
        isSpecialCoolantActive = (coolants[c].id == COOLANT_THROUGH_TOOL) || (coolants[c].id == COOLANT_FLOOD_THROUGH_TOOL) || (coolants[c].id == COOLANT_AIR_THROUGH_TOOL);
        coolantCodes.on = coolants[c].on;
        if (coolants[c].off != undefined) {
          coolantCodes.off = coolants[c].off;
          break;
        } else {
          for (var i in coolants) {
            if (coolants[i].id == COOLANT_OFF) {
              coolantCodes.off = coolants[i].off;
              break;
            }
          }
        }
      }
    }
    if (coolant == COOLANT_OFF) {
      m = !coolantOff ? coolantCodes.off : coolantOff; // use the default coolant off command when an 'off' value is not specified
    } else {
      coolantOff = coolantCodes.off;
      m = coolantCodes.on;
    }
  
    if (!m) {
      onUnsupportedCoolant(coolant);
      m = 9;
    } else {
      if (Array.isArray(m)) {
        for (var i in m) {
          multipleCoolantBlocks.push(mFormat.format(m[i]));
        }
      } else {
        multipleCoolantBlocks.push(mFormat.format(m));
      }
      currentCoolantMode = coolant;
      return multipleCoolantBlocks; // return the single formatted coolant value
    }
    return undefined;
  }

  var mapCommand = {
    COMMAND_STOP:0,
    COMMAND_OPTIONAL_STOP:1,
    COMMAND_END:2,
    COMMAND_SPINDLE_CLOCKWISE:3,
    COMMAND_SPINDLE_COUNTERCLOCKWISE:4,
    COMMAND_STOP_SPINDLE:5,
    COMMAND_ORIENTATE_SPINDLE:19,
    COMMAND_LOAD_TOOL:6
  };

  function onCommand(command) {
    switch (command) {
    case COMMAND_STOP:
      writeBlock(mFormat.format(0));
      forceSpindleSpeed = true;
      return;
    case COMMAND_COOLANT_ON:
      setCoolant(COOLANT_FLOOD);
      return;
    case COMMAND_COOLANT_OFF:
      setCoolant(COOLANT_OFF);
      return;
    case COMMAND_START_SPINDLE:
      onCommand(tool.clockwise ? COMMAND_SPINDLE_CLOCKWISE : COMMAND_SPINDLE_COUNTERCLOCKWISE);
      return;
    case COMMAND_LOCK_MULTI_AXIS:
      if (machineConfiguration.isMultiAxisConfiguration() && (machineConfiguration.getNumberOfAxes() >= 4)) {
        var _skipBlock = skipBlock;
        writeBlock(mFormat.format(10)); // lock 4th-axis motion
        if (machineConfiguration.getNumberOfAxes() == 5) {
          skipBlock = _skipBlock;
          writeBlock(mFormat.format(12)); // lock 5th-axis motion
        }
      }
      return;
    case COMMAND_UNLOCK_MULTI_AXIS:
      if (machineConfiguration.isMultiAxisConfiguration() && (machineConfiguration.getNumberOfAxes() >= 4)) {
        var _skipBlock = skipBlock;
        writeBlock(mFormat.format(11)); // unlock 4th-axis motion
        if (machineConfiguration.getNumberOfAxes() == 5) {
          skipBlock = _skipBlock;
          writeBlock(mFormat.format(13)); // unlock 5th-axis motion
        }
      }
      return;
    case COMMAND_BREAK_CONTROL:
      if (!toolChecked) { // avoid duplicate COMMAND_BREAK_CONTROL
        onCommand(COMMAND_STOP_SPINDLE);
        onCommand(COMMAND_COOLANT_OFF);
        writeBlock(
          gFormat.format(65),
          "P" + 9853,
          "T" + toolFormat.format(tool.number),
          "B" + xyzFormat.format(0),
          "H" + xyzFormat.format(properties.toolBreakageTolerance)
        );
        toolChecked = true;
      }
      return;
    case COMMAND_TOOL_MEASURE:
      measureTool = true;
      return;
    case COMMAND_START_CHIP_TRANSPORT:
      writeBlock(mFormat.format(31));
      return;
    case COMMAND_STOP_CHIP_TRANSPORT:
      writeBlock(mFormat.format(33));
      return;
    case COMMAND_PROBE_ON:
      return;
    case COMMAND_PROBE_OFF:
      return;
    }
    
    var stringId = getCommandStringId(command);
    var mcode = mapCommand[stringId];
    if (mcode != undefined) {
      writeBlock(mFormat.format(mcode));
    } else {
      onUnsupportedCommand(command);
    }
  }

  /** Output block to do safe retract and/or move to home position. */
function writeRetract() {
    // initialize routine
    var _xyzMoved = new Array(false, false, false);
    var _useG28 = properties.useG28; // can be either true or false
  
    // check syntax of call
    if (arguments.length == 0) {
      error(localize("No axis specified for writeRetract()."));
      return;
    }
    for (var i = 0; i < arguments.length; ++i) {
      if ((arguments[i] < 0) || (arguments[i] > 2)) {
        error(localize("Bad axis specified for writeRetract()."));
        return;
      }
      if (_xyzMoved[arguments[i]]) {
        error(localize("Cannot retract the same axis twice in one line"));
        return;
      }
      _xyzMoved[arguments[i]] = true;
    }
    
    // special conditions
    if (_useG28 && _xyzMoved[2] && (_xyzMoved[0] || _xyzMoved[1])) { // XY don't use G28
      error(localize("You cannot move home in XY & Z in the same block."));
      return;
    }
    if (_xyzMoved[0] || _xyzMoved[1]) {
      _useG28 = false;
    }
  
    // define home positions
    var _xHome;
    var _yHome;
    var _zHome;
    if (_useG28) {
      _xHome = 0;
      _yHome = 0;
      _zHome = 0;
    } else {
      if (properties.homePositionCenter &&
        hasParameter("part-upper-x") && hasParameter("part-lower-x")) {
        _xHome = (getParameter("part-upper-x") + getParameter("part-lower-x")) / 2;
      } else {
        _xHome = machineConfiguration.hasHomePositionX() ? machineConfiguration.getHomePositionX() : 0;
      }
      _yHome = machineConfiguration.hasHomePositionY() ? machineConfiguration.getHomePositionY() : 0;
      _zHome = machineConfiguration.getRetractPlane();
    }
  
    // format home positions
    var words = []; // store all retracted axes in an array
    for (var i = 0; i < arguments.length; ++i) {
      // define the axes to move
      switch (arguments[i]) {
      case X:
        // special conditions
        if (properties.homePositionCenter) { // output X in standard block by itself if centering
          writeBlock(gMotionModal.format(0), xOutput.format(_xHome));
          _xyzMoved[0] = false;
          break;
        }
        words.push("X" + xyzFormat.format(_xHome));
        break;
      case Y:
        words.push("Y" + xyzFormat.format(_yHome));
        break;
      case Z:
        words.push("Z" + xyzFormat.format(_zHome));
        retracted = !skipBlock;
        break;
      }
    }
  
    // output move to home
    if (words.length > 0) {
      if (_useG28) {
        gAbsIncModal.reset();
        writeBlock(gFormat.format(28), gAbsIncModal.format(91), words);
        writeBlock(gAbsIncModal.format(90));
      } else {
        gMotionModal.reset();
        writeBlock(gAbsIncModal.format(90), gFormat.format(53), gMotionModal.format(0), words);
      }
  
      // force any axes that move to home on next block
      if (_xyzMoved[0]) {
        xOutput.reset();
      }
      if (_xyzMoved[1]) {
        yOutput.reset();
      }
      if (_xyzMoved[2]) {
        zOutput.reset();
      }
    }
  }

  function onClose() {
    writeln("");
  
    optionalSection = false;
  
    onCommand(COMMAND_STOP_SPINDLE);
    onCommand(COMMAND_COOLANT_OFF);
  
    // retract
    writeRetract(Z);
    zOutput.reset();
  
    forceWorkPlane();
    setWorkPlane(new Vector(0, 0, 0)); // reset working plane
    writeBlock(gRotationModal.format(69));
  
    writeRetract(X, Y);
  
    onImpliedCommand(COMMAND_END);
    onImpliedCommand(COMMAND_STOP_SPINDLE);
    writeBlock(mFormat.format(30)); // stop program, spindle stop, coolant off
    if (subprograms.length > 0) {
      writeln("");
      write(subprograms);
    }
    writeln("");
    writeln("%");
  }