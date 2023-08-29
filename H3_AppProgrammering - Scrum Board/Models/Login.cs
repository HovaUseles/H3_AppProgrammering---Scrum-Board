using MongoDB.Entities;
using System.ComponentModel;

namespace H3_AppProgrammering___Scrum_Board.Models
{
    public class Login
    {
        [DefaultValue("FlutterTester")]
        public string Username { get; set; }
        [DefaultValue("FlutterTest")]
        public string Password { get; set; }
    }
}
