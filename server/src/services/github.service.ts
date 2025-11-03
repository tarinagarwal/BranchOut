import { Octokit } from "@octokit/rest";
import { config } from "../config";

export class GitHubService {
  private octokit: Octokit;

  constructor() {
    this.octokit = new Octokit({
      auth: config.github.token,
    });
  }

  async getUserStats(username: string) {
    try {
      // Get user info
      const { data: user } = await this.octokit.users.getByUsername({
        username,
      });

      // Get user repos
      const { data: repos } = await this.octokit.repos.listForUser({
        username,
        sort: "updated",
        per_page: 100,
      });

      // Calculate stats
      const totalStars = repos.reduce(
        (sum, repo) => sum + (repo.stargazers_count || 0),
        0
      );
      const totalForks = repos.reduce(
        (sum, repo) => sum + (repo.forks_count || 0),
        0
      );

      // Get languages
      const languages: { [key: string]: number } = {};
      for (const repo of repos.slice(0, 10)) {
        if (repo.language) {
          languages[repo.language] = (languages[repo.language] || 0) + 1;
        }
      }

      // Get contribution stats (last year)
      const contributionStats = await this.getContributionStats(username);

      return {
        username,
        name: user.name,
        bio: user.bio,
        avatarUrl: user.avatar_url,
        publicRepos: user.public_repos,
        followers: user.followers,
        following: user.following,
        totalStars,
        totalForks,
        languages: Object.entries(languages)
          .sort((a, b) => b[1] - a[1])
          .slice(0, 5)
          .map(([lang]) => lang),
        contributions: contributionStats,
        topRepos: repos
          .sort((a, b) => (b.stargazers_count || 0) - (a.stargazers_count || 0))
          .slice(0, 5)
          .map((repo) => ({
            name: repo.name,
            description: repo.description,
            stars: repo.stargazers_count,
            forks: repo.forks_count,
            language: repo.language,
            url: repo.html_url,
          })),
      };
    } catch (error: any) {
      if (error.status === 404) {
        throw new Error("GitHub user not found");
      }
      throw new Error(`Failed to fetch GitHub stats: ${error.message}`);
    }
  }

  private async getContributionStats(username: string) {
    try {
      // Get events (contributions)
      const { data: events } =
        await this.octokit.activity.listPublicEventsForUser({
          username,
          per_page: 100,
        });

      const now = new Date();
      const oneYearAgo = new Date(
        now.getFullYear() - 1,
        now.getMonth(),
        now.getDate()
      );

      const recentEvents = events.filter((event) => {
        const eventDate = new Date(event.created_at);
        return eventDate >= oneYearAgo;
      });

      return {
        totalEvents: recentEvents.length,
        pushEvents: recentEvents.filter((e) => e.type === "PushEvent").length,
        pullRequestEvents: recentEvents.filter(
          (e) => e.type === "PullRequestEvent"
        ).length,
        issueEvents: recentEvents.filter((e) => e.type === "IssuesEvent")
          .length,
      };
    } catch (error) {
      return {
        totalEvents: 0,
        pushEvents: 0,
        pullRequestEvents: 0,
        issueEvents: 0,
      };
    }
  }

  async verifyUser(username: string): Promise<boolean> {
    try {
      await this.octokit.users.getByUsername({ username });
      return true;
    } catch (error) {
      return false;
    }
  }
}
