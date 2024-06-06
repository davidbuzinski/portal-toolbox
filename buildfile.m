function plan = buildfile
import matlab.buildtool.Task
import matlab.buildtool.tasks.*

plan = buildplan(localfunctions);

plan("clean") = CleanTask;
plan("check") = CodeIssuesTask;
plan("mex") = MexTask("src/getCake.c", "toolbox/+portal");
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