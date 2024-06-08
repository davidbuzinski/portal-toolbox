function plan = buildfile
import matlab.buildtool.Task
import matlab.buildtool.tasks.*

plan = buildplan(localfunctions);

plan("clean") = CleanTask;

plan("check") = CodeIssuesTask;

plan("mex:win64") = MexTask("src/getCake.c", "toolbox/+portal", Options="TARGET=win64");
plan("mex:maca64") = MexTask("src/getCake.c", "toolbox/+portal", Options="TARGET=maca64");
plan("mex:maci64") = MexTask("src/getCake.c", "toolbox/+portal", Options="TARGET=maci64");
plan("mex:glnxa64") = MexTask("src/getCake.c", "toolbox/+portal", Options="TARGET=glnxa64");

plan("test") = TestTask;

plan("packageToolbox").Dependencies = "mex";
plan("packageToolbox").Inputs.PrjFile = plan.files("ToolboxPackaging.prj");
plan("packageToolbox").Outputs.MltbxFile = plan.files("PortalToolbox.mltbx");

plan("assemble") = Task;
plan("assemble").Dependencies = "packageToolbox";

plan("validate") = Task;
plan("validate").Dependencies = ["check", "test"];

plan("build") = Task;
plan("build").Dependencies = ["assemble", "validate"];

plan.DefaultTasks = "build";
end

function packageToolboxTask(ctx)
prjFile = ctx.Task.Inputs.PrjFile.Path;
mltbxFile = ctx.Task.Outputs.MltbxFile.Path;
matlab.addons.toolbox.packageToolbox(prjFile, mltbxFile);
end
