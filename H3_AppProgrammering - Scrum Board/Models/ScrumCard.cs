using H3_AppProgrammering___Scrum_Board.DTO;
using MongoDB.Entities;

namespace H3_AppProgrammering___Scrum_Board.Models
{
    public class ScrumCard : Entity
    {
        public int Index { get; set; }
        public string Title { get; set; }
        public string Content { get; set; }

        public ScrumCard(
            int index,
            string title,
            string content)
        {
            Index = index;
            Title = title;
            Content = content;
        }

        // Factories

        /// <summary>
        /// Construct a ScrumCard from a ScrumCard DTO
        /// </summary>
        /// <param name="dto"></param>
        public ScrumCard(ScrumCardDTO dto) 
            : this (dto.Index, dto.Title, dto.Content)
        {
            
        }
    }
}
