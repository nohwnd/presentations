using System.Management.Automation;

namespace ComputerCommands
{
    [Cmdlet(VerbsCommon.Set, "AComputer")]
    public class SetAComputerCommand : Cmdlet
    {
        [Parameter(Mandatory = true, ValueFromPipeline = true)]
        public Computer InputObject { get; set; }

        protected override void EndProcessing()
        {
            WriteVerbose($"Saved computer {InputObject.Name}, with description {InputObject.Description}");
        }
    }
}