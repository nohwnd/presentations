namespace PokeBrowser
{
    public class PokemonLinkViewModel : ViewModelBase { 
        private string _name;
        private string _url;

        public string Name
        {
            get => _name;
            set
            {
                _name = value;
                OnPropertyChanged(nameof(Name));
            }
        }

        public string Url
        {
            get => _url;
            set
            {
                _url = value;
                OnPropertyChanged(nameof(Url));
            }
        }
    }
}