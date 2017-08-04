namespace :demo do
  desc 'pull a repository history into our database'
  task :import, [:url] => [:environment] do |t, args|
    require 'rugged'

    repo_url = URI(args[:url])
    namespace, repo_name = repo_url.path.split('/').map { |x| x.split('.')[0] }.compact

    target_dir = Rails.root.join 'tmp', repo_url.host, namespace, repo_name

    begin
      repo = Rugged::Repository.new target_dir.to_s
      repo.fetch 'origin'
    rescue Rugged::RepositoryError, Rugged::OSError
      repo = Rugged::Repository.clone_at(
        repo_url.to_s,
        target_dir.to_s,
        transfer_progress: lambda { |total_objects, indexed_objects, received_objects, local_objects, total_deltas, indexed_deltas, received_bytes|
          # ...
          puts "received_bytes: #{received_bytes}"
        },
        remote: 'origin'
      )
    end

    walker = Rugged::Walker.new repo
    walker.push repo.head.target
    walker.each do |commit|
      co = Commit.find_by sha: commit.oid

      if co.present?
        co.update commit_message: commit.message,
                  commit_date: commit.committer[:time],
                  author_date: commit.author[:time]
      else
        co = Commit.create! sha: commit.oid,
                            commit_message: commit.message,
                            commit_date: commit.committer[:time],
                            author_date: commit.author[:time]
      end

      commit.parents.map(&:oid).each do |parent_sha|
        parent_co = Commit.find_by sha: parent_sha
        parent_co = Commit.create! sha: parent_sha unless parent_co.present?
        co.parents << parent_co
      end
    end
  end
end
