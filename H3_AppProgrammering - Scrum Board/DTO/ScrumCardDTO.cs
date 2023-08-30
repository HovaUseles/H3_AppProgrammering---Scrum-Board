using System.ComponentModel.DataAnnotations;

namespace H3_AppProgrammering___Scrum_Board.DTO
{
    public class ScrumCardDTO
    {
        [Required]
        public int Index { get; set; }

        [Required]
        public string Title { get; set; }

        [Required]
        public string Content { get; set; }
    }
}
