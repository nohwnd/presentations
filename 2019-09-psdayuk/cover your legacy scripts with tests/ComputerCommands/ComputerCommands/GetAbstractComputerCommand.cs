using System.Management.Automation;

namespace ComputerCommands
{
    [Cmdlet(VerbsCommon.Get, "AComputer")]
    public class GetAComputerCommand : Cmdlet
    {
        [Parameter(Mandatory = true)]
        public string Name { get; set; }

        protected override void EndProcessing()
        {
            WriteObject(new LocalComputer(
                Name, 
                $"This is computer {Name}."));
        }
    }
}