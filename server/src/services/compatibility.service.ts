export class CompatibilityService {
  calculateCompatibilityScore(
    user1TechStack: string[],
    user2TechStack: string[],
    user1LookingFor: string[],
    user2LookingFor: string[]
  ): number {
    // Tech stack overlap (70% weight)
    const techOverlap = this.calculateOverlap(user1TechStack, user2TechStack);
    const techScore = techOverlap * 0.7;

    // Goals alignment (30% weight)
    const goalsOverlap = this.calculateGoalsAlignment(
      user1LookingFor,
      user2LookingFor
    );
    const goalsScore = goalsOverlap * 0.3;

    // Total score (0-100)
    const totalScore = Math.round((techScore + goalsScore) * 100);

    return Math.min(100, Math.max(0, totalScore));
  }

  private calculateOverlap(array1: string[], array2: string[]): number {
    if (array1.length === 0 || array2.length === 0) return 0;

    const set1 = new Set(array1.map((item) => item.toLowerCase()));
    const set2 = new Set(array2.map((item) => item.toLowerCase()));

    const intersection = new Set([...set1].filter((x) => set2.has(x)));
    const union = new Set([...set1, ...set2]);

    return intersection.size / union.size;
  }

  private calculateGoalsAlignment(goals1: string[], goals2: string[]): number {
    if (goals1.length === 0 || goals2.length === 0) return 0;

    // Check for complementary goals
    const complementaryPairs = [
      ["Mentor", "Mentee"],
      ["Mentee", "Mentor"],
      ["Co-founder", "Co-founder"],
      ["Collaborator", "Collaborator"],
    ];

    let alignmentScore = 0;

    for (const goal1 of goals1) {
      for (const goal2 of goals2) {
        // Exact match
        if (goal1 === goal2) {
          alignmentScore += 1;
        }
        // Complementary match
        else if (
          complementaryPairs.some(
            ([a, b]) =>
              (goal1 === a && goal2 === b) || (goal1 === b && goal2 === a)
          )
        ) {
          alignmentScore += 1.2; // Bonus for complementary goals
        }
      }
    }

    // Normalize by the maximum possible score
    const maxScore = Math.max(goals1.length, goals2.length);
    return Math.min(1, alignmentScore / maxScore);
  }

  generateIcebreakers(sharedTech: string[], sharedGoals: string[]): string[] {
    const icebreakers: string[] = [];

    if (sharedTech.length > 0) {
      icebreakers.push(
        `I see you also work with ${sharedTech
          .slice(0, 2)
          .join(" and ")}! What's your favorite project using ${sharedTech[0]}?`
      );
    }

    if (sharedGoals.includes("Mentor") || sharedGoals.includes("Mentee")) {
      icebreakers.push(
        "I'd love to learn more about your experience. What's the most valuable lesson you've learned in your career?"
      );
    }

    if (sharedGoals.includes("Co-founder")) {
      icebreakers.push(
        "I'm interested in building something together. What kind of projects are you passionate about?"
      );
    }

    if (sharedGoals.includes("Collaborator")) {
      icebreakers.push(
        "I'm always looking for collaboration opportunities. What are you currently working on?"
      );
    }

    if (icebreakers.length === 0) {
      icebreakers.push(
        "Hey! I'd love to connect and learn more about your work.",
        "Hi! Your profile caught my attention. What are you currently working on?",
        "Hello! I think we could have some interesting conversations about tech."
      );
    }

    return icebreakers.slice(0, 3);
  }
}
