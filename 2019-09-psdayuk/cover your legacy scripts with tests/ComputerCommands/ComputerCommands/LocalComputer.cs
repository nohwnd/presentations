namespace ComputerCommands
{
    internal class LocalComputer : Computer
    {
        public LocalComputer(string name, string description)
        {
            Name = name;
            Description = description;
        }

        public string Name { get; }
        public string Description { get; set; }
    }
}