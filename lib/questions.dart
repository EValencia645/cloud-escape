import 'dart:math';

class Question {
  final String question;
  final List<String> options;
  final int correctIndex;
  final String meme;

  Question({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.meme,
  });
}

class Category {
  final String id;
  final String emoji;
  final String title;
  final String roomName;
  final List<Question> questions; // full bank (30)

  // Not const — keeps questions as a runtime list so shuffling always works
  Category({
    required this.id,
    required this.emoji,
    required this.title,
    required this.roomName,
    required this.questions,
  });

  /// Returns a shuffled random sample of [count] questions from the bank.
  /// Uses a time-based seed so each call produces a genuinely different order,
  /// including on Flutter web where Random() can be deterministic.
  List<Question> randomSample({int count = 20}) {
    final rng = Random(DateTime.now().microsecondsSinceEpoch);
    final shuffled = [...questions]..shuffle(rng);
    return shuffled.take(count).toList();
  }
}

final List<Category> allCategories = [
  // ─────────────────────────────────────────
  //  ☁️  AWS  (20 questions)
  // ─────────────────────────────────────────
  Category(
    id: 'aws',
    emoji: '☁️',
    title: 'AWS',
    roomName: 'The S3 Vault',
    questions: [
      Question(
        question: 'Which AWS service stores objects (files)?',
        options: ['EC2', 'Lambda', 'S3', 'VPC'],
        correctIndex: 2,
        meme: '🪣 S3: Because your files deserve a home in the cloud!',
      ),
      Question(
        question: 'EC2 stands for…?',
        options: [
          'Elastic Compute Cloud',
          'Extra Cool Computers',
          'Encrypted Cloud Cache',
          'Elastic Container Cluster',
        ],
        correctIndex: 0,
        meme: '💻 EC2: Just a fancy way to say "rented computer".',
      ),
      Question(
        question: 'Which service runs code WITHOUT managing servers?',
        options: ['EC2', 'RDS', 'Lambda', 'Glacier'],
        correctIndex: 2,
        meme: '🪄 Lambda: Magic code — runs itself, no server babysitting required!',
      ),
      Question(
        question: 'What does IAM stand for?',
        options: [
          'Internet Access Manager',
          'Identity and Access Management',
          'Internal AWS Module',
          'Integrated App Machine',
        ],
        correctIndex: 1,
        meme: '🔑 IAM: The bouncer of your AWS nightclub.',
      ),
      Question(
        question: 'Which service is a managed relational database?',
        options: ['DynamoDB', 'S3', 'RDS', 'ElastiCache'],
        correctIndex: 2,
        meme: '🗃️ RDS: Because manually managing databases is a nightmare!',
      ),
      Question(
        question: 'What is AWS CloudFront used for?',
        options: [
          'Storing database backups',
          'Content delivery network (CDN)',
          'Running containers',
          'Monitoring logs',
        ],
        correctIndex: 1,
        meme: '🚀 CloudFront: Making your website fast everywhere, even in the middle of nowhere.',
      ),
      Question(
        question: 'Which AWS service monitors resources and sends alerts?',
        options: ['CloudTrail', 'CloudWatch', 'Config', 'Inspector'],
        correctIndex: 1,
        meme: '📊 CloudWatch: The spy that actually tells you what\'s going wrong.',
      ),
      Question(
        question: 'What does VPC stand for?',
        options: [
          'Virtual Private Cloud',
          'Very Powerful Computer',
          'Virtual Public Container',
          'Verified Private Connection',
        ],
        correctIndex: 0,
        meme: '🏠 VPC: Your own private neighbourhood inside AWS.',
      ),
      Question(
        question: 'Which service manages DNS in AWS?',
        options: ['Shield', 'Route 53', 'WAF', 'CloudFront'],
        correctIndex: 1,
        meme: '🗺️ Route 53: Named after port 53. AWS loves a good pun.',
      ),
      Question(
        question: 'What is the AWS free tier primarily used for?',
        options: [
          'Running production workloads for free',
          'Exploring and testing AWS services',
          'Unlimited storage forever',
          'Free enterprise support',
        ],
        correctIndex: 1,
        meme: '💸 AWS Free Tier: "Free" until you forget to turn something off.',
      ),
      // ── 10 new AWS questions ──────────────────────────────────────────────
      Question(
        question: 'What is Amazon SQS used for?',
        options: [
          'Streaming video content',
          'Sending and receiving messages between services',
          'Storing relational data',
          'Running batch jobs',
        ],
        correctIndex: 1,
        meme: '📬 SQS: The world\'s most patient post office — messages wait forever.',
      ),
      Question(
        question: 'Which AWS service is used to run Docker containers without managing servers?',
        options: ['ECS on EC2', 'AWS Fargate', 'Elastic Beanstalk', 'AWS Batch'],
        correctIndex: 1,
        meme: '🐳 Fargate: Containers without the server babysitting. Docker is happy.',
      ),
      Question(
        question: 'What does Amazon SNS stand for?',
        options: [
          'Simple Notification Service',
          'Secure Network Service',
          'Storage Node System',
          'Simple Networking Stack',
        ],
        correctIndex: 0,
        meme: '📣 SNS: AWS shouting your message to everyone who\'ll listen.',
      ),
      Question(
        question: 'Which AWS service lets you run code on a schedule (like a cron job)?',
        options: ['CloudWatch Events / EventBridge', 'SQS', 'SNS', 'Step Functions'],
        correctIndex: 0,
        meme: '⏰ EventBridge: AWS cron — because someone has to remember to run the thing.',
      ),
      Question(
        question: 'What is AWS Elastic Beanstalk?',
        options: [
          'A NoSQL database',
          'A content delivery network',
          'A platform that automatically handles deployment, scaling, and monitoring',
          'A serverless compute service',
        ],
        correctIndex: 2,
        meme: '🫘 Elastic Beanstalk: Upload code, AWS figures out the rest. Magic? Almost.',
      ),
      Question(
        question: 'Which service provides a fully managed Kubernetes control plane?',
        options: ['ECS', 'EKS', 'ECR', 'Fargate'],
        correctIndex: 1,
        meme: '⚙️ EKS: Kubernetes, but AWS handles the part where it breaks at 3 AM.',
      ),
      Question(
        question: 'What is Amazon Glacier primarily used for?',
        options: [
          'High-speed caching',
          'Low-cost long-term data archiving',
          'Real-time analytics',
          'Running containerised apps',
        ],
        correctIndex: 1,
        meme: '🧊 Glacier: Cheap storage for data you hope you never need to retrieve quickly.',
      ),
      Question(
        question: 'What does AWS CloudTrail do?',
        options: [
          'Speeds up static websites',
          'Logs all API calls made in your AWS account',
          'Manages SSL certificates',
          'Distributes traffic across servers',
        ],
        correctIndex: 1,
        meme: '🕵️ CloudTrail: AWS\'s security camera — it saw what you did in the console.',
      ),
      Question(
        question: 'Which service would you use to store and version Docker images?',
        options: ['S3', 'ECR', 'CodeArtifact', 'ECS'],
        correctIndex: 1,
        meme: '🐋 ECR: Docker Hub but AWS-flavoured. Comes with the same confused looks.',
      ),
      Question(
        question: 'What is the main benefit of using Auto Scaling in AWS?',
        options: [
          'Reduces your S3 costs',
          'Automatically adds or removes compute capacity based on demand',
          'Encrypts your data at rest',
          'Speeds up database queries',
        ],
        correctIndex: 1,
        meme: '📈 Auto Scaling: Your app handles Black Friday traffic without you panic-clicking.',
      ),
      // ── 10 more AWS questions ─────────────────────────────────────────────
      Question(
        question: 'What is AWS Step Functions used for?',
        options: [
          'Storing step-by-step documentation',
          'Coordinating multi-step serverless workflows',
          'Monitoring Lambda execution time',
          'Managing EC2 instance states',
        ],
        correctIndex: 1,
        meme: '🪜 Step Functions: Workflow orchestration so your Lambdas stop calling each other directly like barbarians.',
      ),
      Question(
        question: 'What does Amazon ElastiCache provide?',
        options: [
          'Long-term cold storage',
          'In-memory caching to speed up applications',
          'Automated database backups',
          'CDN for static assets',
        ],
        correctIndex: 1,
        meme: '⚡ ElastiCache: RAM-speed data. Because your database is tired of answering the same question.',
      ),
      Question(
        question: 'What is the purpose of an AWS Availability Zone?',
        options: [
          'A pricing tier for reserved instances',
          'An isolated data center location for fault tolerance',
          'A region-wide backup system',
          'A virtual private network endpoint',
        ],
        correctIndex: 1,
        meme: '🏗️ Availability Zones: Because putting all your eggs in one data center is a bad idea.',
      ),
      Question(
        question: 'Which AWS service provides a managed message broker?',
        options: ['SQS', 'SNS', 'Amazon MQ', 'Kinesis'],
        correctIndex: 2,
        meme: '📨 Amazon MQ: For when you need RabbitMQ but don\'t want to babysit the server.',
      ),
      Question(
        question: 'What is AWS WAF?',
        options: [
          'A data warehouse service',
          'A web application firewall that filters malicious traffic',
          'A workflow automation framework',
          'A managed VPN service',
        ],
        correctIndex: 1,
        meme: '🛡️ WAF: The bouncer that reads HTTP requests instead of IDs.',
      ),
      Question(
        question: 'What does Amazon Kinesis do?',
        options: [
          'Runs containerised workloads',
          'Processes real-time streaming data',
          'Manages DNS records',
          'Stores archival backups',
        ],
        correctIndex: 1,
        meme: '🌊 Kinesis: Because sometimes your data arrives faster than you can say "batch job".',
      ),
      Question(
        question: 'What is an S3 bucket policy used for?',
        options: [
          'Setting storage class of objects',
          'Controlling access permissions to the bucket',
          'Enabling versioning on objects',
          'Configuring static website hosting',
        ],
        correctIndex: 1,
        meme: '📜 S3 bucket policy: The fine print that decides who gets to touch your files.',
      ),
      Question(
        question: 'Which AWS service manages SSL/TLS certificates for free?',
        options: ['IAM', 'KMS', 'ACM (Certificate Manager)', 'Secrets Manager'],
        correctIndex: 2,
        meme: '🔏 ACM: Free SSL certs, auto-renewed. No more 2 AM "your cert expired" panic.',
      ),
      Question(
        question: 'What is AWS Secrets Manager used for?',
        options: [
          'Encrypting S3 objects',
          'Storing and rotating sensitive credentials securely',
          'Managing IAM user passwords',
          'Logging API calls',
        ],
        correctIndex: 1,
        meme: '🤫 Secrets Manager: For when hardcoding passwords in your repo finally gets embarrassing.',
      ),
      Question(
        question: 'What is the purpose of an AWS Transit Gateway?',
        options: [
          'Connecting on-premises networks to the internet',
          'Centrally connecting multiple VPCs and on-premises networks',
          'Managing API routing rules',
          'Providing dedicated connections to AWS',
        ],
        correctIndex: 1,
        meme: '🔀 Transit Gateway: The hub-and-spoke model for people tired of peering every VPC manually.',
      ),
    ],
  ),

  // ─────────────────────────────────────────
  //  🔐  Security  (20 questions)
  // ─────────────────────────────────────────
  Category(
    id: 'security',
    emoji: '🔐',
    title: 'Security',
    roomName: 'The Cipher Chamber',
    questions: [
      Question(
        question: 'What does HTTPS stand for?',
        options: [
          'HyperText Transfer Protocol Secure',
          'High Traffic Protocol System',
          'Hosted Text Page Secure',
          'HyperText Transfer Process Service',
        ],
        correctIndex: 0,
        meme: '🔒 HTTPS: The little padlock that says "I pinky promise I\'m safe".',
      ),
      Question(
        question: 'What is a "phishing" attack?',
        options: [
          'Flooding a server with traffic',
          'Tricking users into revealing credentials',
          'Encrypting files for ransom',
          'Intercepting network packets',
        ],
        correctIndex: 1,
        meme: '🎣 Phishing: Hackers casting a rod into your inbox.',
      ),
      Question(
        question: 'Which of these is the strongest password?',
        options: ['password123', 'qwerty', 'Tr0ub4dor&3!xK', 'myname2024'],
        correctIndex: 2,
        meme: '💪 Strong password: Looks like your cat walked on the keyboard.',
      ),
      Question(
        question: 'What is two-factor authentication (2FA)?',
        options: [
          'Two passwords required',
          'A backup login email',
          'A second verification step beyond your password',
          'Logging in from two devices',
        ],
        correctIndex: 2,
        meme: '📱 2FA: Even if hackers get your password, they\'re still locked out. Ha!',
      ),
      Question(
        question: 'What does a firewall do?',
        options: [
          'Speeds up internet',
          'Encrypts your hard drive',
          'Monitors and controls network traffic',
          'Backs up your files',
        ],
        correctIndex: 2,
        meme: '🧱 Firewall: The bouncer that actually reads the guest list.',
      ),
      Question(
        question: 'What is ransomware?',
        options: [
          'Software that speeds up your PC',
          'Malware that encrypts your files and demands payment',
          'A type of phishing email',
          'A network scanning tool',
        ],
        correctIndex: 1,
        meme: '💰 Ransomware: "Nice files you have there. Shame if something happened to them."',
      ),
      Question(
        question: 'What is the principle of least privilege?',
        options: [
          'Give all users admin access',
          'Restrict users to only the access they need',
          'Store passwords in plain text',
          'Share login credentials among a team',
        ],
        correctIndex: 1,
        meme: '🤏 Least privilege: Your intern doesn\'t need root access. Trust me.',
      ),
      Question(
        question: 'What does SSL/TLS do?',
        options: [
          'Blocks malware',
          'Speeds up downloads',
          'Encrypts data in transit',
          'Authenticates users',
        ],
        correctIndex: 2,
        meme: '🛡️ TLS: The invisible bodyguard for your data packets.',
      ),
      Question(
        question: 'What is a DDoS attack?',
        options: [
          'Stealing credentials via email',
          'Overwhelming a service with massive traffic',
          'Injecting SQL into a database',
          'Cracking encryption keys',
        ],
        correctIndex: 1,
        meme: '🌊 DDoS: Imagine everyone trying to enter a shop at the same time. But meaner.',
      ),
      Question(
        question: 'What does "zero trust" mean in security?',
        options: [
          'Trust no one, verify everything',
          'Disable all firewalls',
          'Only trust internal networks',
          'Remove all passwords',
        ],
        correctIndex: 0,
        meme: '🕵️ Zero Trust: Even your fridge is a suspect.',
      ),
      // ── 10 new Security questions ─────────────────────────────────────────
      Question(
        question: 'What is SQL injection?',
        options: [
          'A way to speed up database queries',
          'Inserting malicious SQL code into an input field to manipulate a database',
          'A method of encrypting SQL data',
          'A type of database backup',
        ],
        correctIndex: 1,
        meme: '💉 SQL Injection: Little Bobby Tables strikes again. (xkcd fans know.)',
      ),
      Question(
        question: 'What is a man-in-the-middle (MITM) attack?',
        options: [
          'Guessing passwords repeatedly',
          'Secretly intercepting communication between two parties',
          'Overloading a server with requests',
          'Installing malware via USB',
        ],
        correctIndex: 1,
        meme: '🤝 MITM: "Hey, I\'ll pass your messages along." (reads every single one)',
      ),
      Question(
        question: 'What does a password manager do?',
        options: [
          'Resets your forgotten passwords automatically',
          'Stores and generates strong, unique passwords securely',
          'Shares passwords with your team',
          'Monitors login attempts',
        ],
        correctIndex: 1,
        meme: '🔐 Password manager: 1Password to rule them all. Still better than "password1".',
      ),
      Question(
        question: 'What is social engineering in cybersecurity?',
        options: [
          'Building secure social media apps',
          'Manipulating people into revealing confidential information',
          'Engineering firewall rules',
          'Coding secure login forms',
        ],
        correctIndex: 1,
        meme: '🎭 Social engineering: When hackers use charm instead of code. Scarier.',
      ),
      Question(
        question: 'What does "encryption at rest" mean?',
        options: [
          'Encrypting data while it travels over the network',
          'Pausing encryption temporarily',
          'Encrypting data while it\'s stored on disk',
          'Encrypting only backup copies',
        ],
        correctIndex: 2,
        meme: '😴 Encryption at rest: Your data is sleeping safely. No unauthorised spooning.',
      ),
      Question(
        question: 'What is a CVE?',
        options: [
          'A type of firewall rule',
          'A publicly disclosed cybersecurity vulnerability',
          'A certificate verification engine',
          'A cloud vendor evaluation',
        ],
        correctIndex: 1,
        meme: '📋 CVE: Vulnerability hall of shame. Check if YOUR software is on the list.',
      ),
      Question(
        question: 'What is the purpose of a CAPTCHA?',
        options: [
          'Speed up form submissions',
          'Distinguish between humans and bots',
          'Encrypt form data',
          'Validate email addresses',
        ],
        correctIndex: 1,
        meme: '🚦 CAPTCHA: Proving you\'re human by identifying blurry traffic lights. Relatable.',
      ),
      Question(
        question: 'What is a brute force attack?',
        options: [
          'Physically stealing a server',
          'Trying every possible password combination until one works',
          'Exploiting a software bug',
          'Sending thousands of phishing emails',
        ],
        correctIndex: 1,
        meme: '🔨 Brute force: The "try every key on the keyring" approach to hacking.',
      ),
      Question(
        question: 'What does OWASP stand for?',
        options: [
          'Open Web Application Security Project',
          'Official Web Authentication Standard Protocol',
          'Online Vulnerability Assessment Software Platform',
          'Open Wireless Access Security Protocol',
        ],
        correctIndex: 0,
        meme: '📜 OWASP: The security bible developers pretend to have read.',
      ),
      Question(
        question: 'Which of these is an example of multi-factor authentication?',
        options: [
          'Password + security question',
          'Password + SMS code',
          'Username + password',
          'Email + password',
        ],
        correctIndex: 1,
        meme: '📲 SMS 2FA: Better than nothing. Worse than an authenticator app. Still use it.',
      ),
      // ── 10 more Security questions ────────────────────────────────────────
      Question(
        question: 'What is a honeypot in cybersecurity?',
        options: [
          'A sweet-sounding malware strain',
          'A decoy system designed to lure and detect attackers',
          'An encrypted password storage method',
          'A type of network proxy',
        ],
        correctIndex: 1,
        meme: '🍯 Honeypot: "Come in, hackers, everything is fine here." — definitely not a trap.',
      ),
      Question(
        question: 'What does PII stand for?',
        options: [
          'Private Internet Infrastructure',
          'Personally Identifiable Information',
          'Protected IP Interface',
          'Primary Identity Index',
        ],
        correctIndex: 1,
        meme: '🪪 PII: Your name, email, SSN — stuff you really don\'t want in a breach. Guard it.',
      ),
      Question(
        question: 'What is penetration testing?',
        options: [
          'Testing network bandwidth limits',
          'Authorised simulated attacks to find security vulnerabilities',
          'Stress-testing a web server',
          'Scanning for malware on endpoints',
        ],
        correctIndex: 1,
        meme: '🔓 Pen testing: Getting paid to hack things legally. The dream job.',
      ),
      Question(
        question: 'What is an intrusion detection system (IDS)?',
        options: [
          'A firewall that blocks all traffic',
          'A system that monitors for suspicious activity and alerts',
          'A VPN tunnel manager',
          'An antivirus scanning engine',
        ],
        correctIndex: 1,
        meme: '🚨 IDS: The smoke alarm of your network. Loud, sometimes annoying, but glad it\'s there.',
      ),
      Question(
        question: 'What does "salting" a password mean?',
        options: [
          'Encrypting it with AES-256',
          'Adding a random value before hashing to prevent rainbow table attacks',
          'Storing it in plain text with a prefix',
          'Applying two rounds of MD5',
        ],
        correctIndex: 1,
        meme: '🧂 Password salting: Making sure two identical passwords hash differently. Gordon Ramsay approves.',
      ),
      Question(
        question: 'What is a security token in AWS?',
        options: [
          'A physical USB key for MFA',
          'A temporary credential used to access AWS resources',
          'An encrypted API key stored in S3',
          'A certificate for SSL/TLS',
        ],
        correctIndex: 1,
        meme: '🎟️ Security token: A temporary VIP pass that expires before you can do too much damage.',
      ),
      Question(
        question: 'What is the purpose of a DMZ in network security?',
        options: [
          'To speed up internal network traffic',
          'A buffer zone between the public internet and internal network',
          'To encrypt all outbound traffic',
          'To store sensitive data safely',
        ],
        correctIndex: 1,
        meme: '🏚️ DMZ: The neighbourhood between the internet and your sensitive stuff. Rough area.',
      ),
      Question(
        question: 'What does "defence in depth" mean?',
        options: [
          'Using the strongest single security control available',
          'Layering multiple security controls so failing one doesn\'t expose everything',
          'Encrypting data three times',
          'Running security audits quarterly',
        ],
        correctIndex: 1,
        meme: '🧅 Defence in depth: Like an onion — lots of layers, makes attackers cry.',
      ),
      Question(
        question: 'What is a security audit?',
        options: [
          'An automated malware scan',
          'A systematic review of security policies, controls, and systems',
          'A firewall rule update process',
          'A password rotation schedule',
        ],
        correctIndex: 1,
        meme: '📋 Security audit: The annual event where everyone panics and updates their passwords.',
      ),
      Question(
        question: 'What is credential stuffing?',
        options: [
          'Filling out login forms automatically for testing',
          'Using leaked username/password pairs to try to access other services',
          'Storing credentials in environment variables',
          'Brute-forcing a single account repeatedly',
        ],
        correctIndex: 1,
        meme: '🧳 Credential stuffing: "You reused that password? Let me try it on your bank." — hackers, probably.',
      ),
    ],
  ),

  // ─────────────────────────────────────────
  //  🐧  Linux  (20 questions)
  // ─────────────────────────────────────────
  Category(
    id: 'linux',
    emoji: '🐧',
    title: 'Linux',
    roomName: 'The Terminal Dungeon',
    questions: [
      Question(
        question: 'Which command lists files in the current directory?',
        options: ['cd', 'ls', 'rm', 'pwd'],
        correctIndex: 1,
        meme: '📂 ls: Asking the terminal "what\'s in here?" politely.',
      ),
      Question(
        question: 'What does "chmod 777" do to a file?',
        options: [
          'Deletes the file',
          'Gives everyone full read/write/execute permissions',
          'Makes the file hidden',
          'Encrypts the file',
        ],
        correctIndex: 1,
        meme: '😬 chmod 777: Security engineers cry every time.',
      ),
      Question(
        question: 'Which command shows your current directory path?',
        options: ['ls', 'cd', 'pwd', 'cat'],
        correctIndex: 2,
        meme: '📍 pwd: "Where am I?" — Linux edition.',
      ),
      Question(
        question: 'What does "sudo" do?',
        options: [
          'Deletes all files',
          'Runs a command as superuser',
          'Shows disk usage',
          'Searches for text',
        ],
        correctIndex: 1,
        meme: '🦸 sudo: With great power comes great "are you sure about this?"',
      ),
      Question(
        question: 'Which command displays the contents of a file?',
        options: ['rm', 'mv', 'cat', 'grep'],
        correctIndex: 2,
        meme: '😸 cat: Named after cats, equally unpredictable.',
      ),
      Question(
        question: 'Which command searches for text patterns in files?',
        options: ['find', 'locate', 'grep', 'awk'],
        correctIndex: 2,
        meme: '🔍 grep: Like Ctrl+F but it makes you feel like a hacker.',
      ),
      Question(
        question: 'What does "rm -rf /" do?',
        options: [
          'Reboots the system',
          'Removes the root directory recursively — deletes everything',
          'Refreshes the file system',
          'Runs a root fix',
        ],
        correctIndex: 1,
        meme: '💥 rm -rf /: The nuclear option. Do NOT try this at home. Or work.',
      ),
      Question(
        question: 'Which command copies a file?',
        options: ['mv', 'cp', 'ln', 'dd'],
        correctIndex: 1,
        meme: '📋 cp: The copy-paste of the terminal world.',
      ),
      Question(
        question: 'What does "ps aux" show?',
        options: [
          'Disk partitions',
          'Network connections',
          'All running processes',
          'User login history',
        ],
        correctIndex: 2,
        meme: '🔭 ps aux: Spying on every process running on your machine.',
      ),
      Question(
        question: 'Which file contains user account information in Linux?',
        options: ['/etc/hosts', '/etc/passwd', '/etc/shadow', '/etc/fstab'],
        correctIndex: 1,
        meme: '👤 /etc/passwd: Passwords not actually stored here anymore. Old habits die hard.',
      ),
      // ── 10 new Linux questions ────────────────────────────────────────────
      Question(
        question: 'Which command shows disk usage of files and directories?',
        options: ['df', 'du', 'ls -s', 'stat'],
        correctIndex: 1,
        meme: '💾 du: "Where did all my disk space go?!" — du will tell you. You won\'t like it.',
      ),
      Question(
        question: 'What does the pipe "|" do in Linux?',
        options: [
          'Runs two commands simultaneously',
          'Sends the output of one command as input to another',
          'Deletes a file',
          'Creates a background process',
        ],
        correctIndex: 1,
        meme: '🔧 Pipes: Chaining commands like a Linux wizard. Feeling powerful yet?',
      ),
      Question(
        question: 'What does "top" show in Linux?',
        options: [
          'The top of a text file',
          'A real-time view of running processes and resource usage',
          'The highest-priority scheduled task',
          'The root directory contents',
        ],
        correctIndex: 1,
        meme: '📊 top: htop\'s less flashy ancestor. Still gets the job done.',
      ),
      Question(
        question: 'Which command changes your current directory?',
        options: ['ls', 'mv', 'cd', 'mkdir'],
        correctIndex: 2,
        meme: '🚶 cd: Navigating the filesystem since the dawn of Unix. A classic.',
      ),
      Question(
        question: 'What is a "cron job"?',
        options: [
          'A type of Linux user account',
          'A scheduled task that runs automatically at defined times',
          'A log rotation utility',
          'A background process manager',
        ],
        correctIndex: 1,
        meme: '⏱️ Cron: Set it and forget it. Then forget you set it. Classic sysadmin move.',
      ),
      Question(
        question: 'What does "chown" do?',
        options: [
          'Changes file permissions',
          'Changes the owner of a file or directory',
          'Creates a new user',
          'Shows file ownership',
        ],
        correctIndex: 1,
        meme: '👑 chown: Bestowing ownership like a Linux king. All hail the new file owner.',
      ),
      Question(
        question: 'Which command shows the last few lines of a file?',
        options: ['head', 'tail', 'cat', 'less'],
        correctIndex: 1,
        meme: '🦊 tail -f: The best way to watch logs scroll forever and feel productive.',
      ),
      Question(
        question: 'What does "ssh" stand for?',
        options: [
          'Secure Shell',
          'Super System Host',
          'Simple Server Handler',
          'System Shell Handler',
        ],
        correctIndex: 0,
        meme: '🔑 SSH: Teleporting into another computer. With encryption. Very cool.',
      ),
      Question(
        question: 'What does "&&" do between two shell commands?',
        options: [
          'Runs both commands regardless of errors',
          'Runs the second command only if the first succeeds',
          'Runs commands in parallel',
          'Pipes output between commands',
        ],
        correctIndex: 1,
        meme: '✅ &&: "Only proceed if that last thing didn\'t blow up." Wise choice.',
      ),
      Question(
        question: 'Which command creates a new directory?',
        options: ['touch', 'newdir', 'mkdir', 'md'],
        correctIndex: 2,
        meme: '📁 mkdir: Creating folders like it\'s 1969. mkdir -p is the power move.',
      ),
      // ── 10 more Linux questions ───────────────────────────────────────────
      Question(
        question: 'What does the ">" operator do in a shell command?',
        options: [
          'Appends output to a file',
          'Redirects output to a file, overwriting it',
          'Pipes output to another command',
          'Compares two values',
        ],
        correctIndex: 1,
        meme: '📄 >: Redirect operator. Overwrites without asking. Learned that one the hard way.',
      ),
      Question(
        question: 'What is the difference between ">" and ">>" in shell?',
        options: [
          '">" appends, ">>" overwrites',
          '">" overwrites, ">>" appends',
          'They are identical',
          '">" is for files, ">>" is for directories',
        ],
        correctIndex: 1,
        meme: '📝 >>: Appends to a file. The responsible sibling of >.',
      ),
      Question(
        question: 'Which command shows network connections and listening ports?',
        options: ['ifconfig', 'ping', 'netstat', 'traceroute'],
        correctIndex: 2,
        meme: '🔌 netstat: "What is MY computer talking to?" Great question. Sometimes terrifying answer.',
      ),
      Question(
        question: 'What does "kill -9" do?',
        options: [
          'Pauses a process',
          'Sends a graceful shutdown signal',
          'Forcefully terminates a process immediately',
          'Lowers process priority',
        ],
        correctIndex: 2,
        meme: '💀 kill -9: The "I said STOP" of process management. No questions asked.',
      ),
      Question(
        question: 'What is /dev/null in Linux?',
        options: [
          'A file containing system error logs',
          'A virtual device that discards all data written to it',
          'The default home directory',
          'A null pointer reference in kernel space',
        ],
        correctIndex: 1,
        meme: '🕳️ /dev/null: The black hole of Linux. Where output goes to die quietly.',
      ),
      Question(
        question: 'What does "df -h" show?',
        options: [
          'Directory file permissions in human-readable format',
          'Disk filesystem usage in human-readable format',
          'Default file handler settings',
          'Detailed file history',
        ],
        correctIndex: 1,
        meme: '💽 df -h: "How full is my disk?" — asked every sysadmin ever, usually too late.',
      ),
      Question(
        question: 'What is a symbolic link (symlink) in Linux?',
        options: [
          'A compressed copy of a file',
          'A shortcut that points to another file or directory',
          'A hidden system file',
          'A read-only file reference',
        ],
        correctIndex: 1,
        meme: '🔗 Symlink: A pointer to a file. Like a shortcut, but cooler and with more edge cases.',
      ),
      Question(
        question: 'What does "env" command show?',
        options: [
          'Installed packages',
          'Current environment variables',
          'Kernel environment settings',
          'Network environment configuration',
        ],
        correctIndex: 1,
        meme: '🌿 env: All your environment variables, including the secrets you forgot were in there.',
      ),
      Question(
        question: 'What does "history" command do in Linux?',
        options: [
          'Shows file modification history',
          'Displays previously run shell commands',
          'Lists recently accessed files',
          'Shows system boot history',
        ],
        correctIndex: 1,
        meme: '📜 history: A journal of every command you\'ve run. Including the embarrassing ones.',
      ),
      Question(
        question: 'What is the purpose of /etc/hosts?',
        options: [
          'Lists all system users',
          'Maps hostnames to IP addresses locally',
          'Stores SSH known hosts',
          'Configures DNS nameservers',
        ],
        correctIndex: 1,
        meme: '📖 /etc/hosts: The OG DNS. Predates the internet. Still works. Respect.',
      ),
    ],
  ),

  // ─────────────────────────────────────────
  //  🌐  Networking  (20 questions)
  // ─────────────────────────────────────────
  Category(
    id: 'networking',
    emoji: '🌐',
    title: 'Networking',
    roomName: 'The Packet Storm',
    questions: [
      Question(
        question: 'What does DNS stand for?',
        options: [
          'Data Network Service',
          'Dynamic Name System',
          'Domain Name System',
          'Distributed Node Server',
        ],
        correctIndex: 2,
        meme: '📖 DNS: The internet\'s phone book. Yes, people used phone books.',
      ),
      Question(
        question: 'What port does HTTPS use by default?',
        options: ['80', '21', '443', '8080'],
        correctIndex: 2,
        meme: '🚪 Port 443: The VIP entrance for secure web traffic.',
      ),
      Question(
        question: 'What is the purpose of an IP address?',
        options: [
          'Encrypt data in transit',
          'Uniquely identify a device on a network',
          'Store website passwords',
          'Speed up downloads',
        ],
        correctIndex: 1,
        meme: '🏠 IP address: Your home address, but for the internet.',
      ),
      Question(
        question: 'What does TCP stand for?',
        options: [
          'Transfer Control Protocol',
          'Transmission Control Protocol',
          'Traffic Check Protocol',
          'Total Connection Package',
        ],
        correctIndex: 1,
        meme: '📦 TCP: Delivery guaranteed. Unlike some couriers.',
      ),
      Question(
        question: 'What is a VPN used for?',
        options: [
          'Speed up your connection',
          'Block ads',
          'Create a secure, encrypted tunnel over the internet',
          'Increase your storage',
        ],
        correctIndex: 2,
        meme: '🕵️ VPN: The invisibility cloak of the internet.',
      ),
      Question(
        question: 'What does a router do?',
        options: [
          'Amplifies Wi-Fi signal',
          'Stores website data',
          'Directs data packets between networks',
          'Encrypts your traffic',
        ],
        correctIndex: 2,
        meme: '🗺️ Router: The traffic cop of your home network.',
      ),
      Question(
        question: 'What port does HTTP (not HTTPS) use?',
        options: ['443', '22', '80', '3306'],
        correctIndex: 2,
        meme: '🚪 Port 80: The unlocked front door. Use HTTPS instead!',
      ),
      Question(
        question: 'What is a subnet mask used for?',
        options: [
          'Encrypt network traffic',
          'Divide an IP address into network and host portions',
          'Speed up routing',
          'Block specific IP addresses',
        ],
        correctIndex: 1,
        meme: '🔪 Subnet mask: Slicing your IP address like a pizza.',
      ),
      Question(
        question: 'What protocol is used to send emails?',
        options: ['FTP', 'HTTP', 'SMTP', 'SNMP'],
        correctIndex: 2,
        meme: '📧 SMTP: The aging postal worker still delivering your emails since 1982.',
      ),
      Question(
        question: 'What does DHCP do?',
        options: [
          'Encrypts network traffic',
          'Automatically assigns IP addresses to devices',
          'Resolves domain names',
          'Monitors network bandwidth',
        ],
        correctIndex: 1,
        meme: '🤖 DHCP: "Here\'s your IP address, please don\'t lose it." — your router, probably.',
      ),
      // ── 10 new Networking questions ───────────────────────────────────────
      Question(
        question: 'What is the difference between TCP and UDP?',
        options: [
          'TCP is faster; UDP is more reliable',
          'TCP guarantees delivery; UDP does not',
          'UDP is encrypted; TCP is not',
          'They are identical protocols',
        ],
        correctIndex: 1,
        meme: '🎲 UDP: "I\'ll send it and hope for the best." Perfect for video calls apparently.',
      ),
      Question(
        question: 'What does a MAC address identify?',
        options: [
          'A website\'s location on the internet',
          'A network interface hardware address',
          'A mobile app certificate',
          'A router\'s IP assignment',
        ],
        correctIndex: 1,
        meme: '🪪 MAC address: Your device\'s unique fingerprint. No two are the same. Usually.',
      ),
      Question(
        question: 'What is the loopback address in IPv4?',
        options: ['192.168.0.1', '10.0.0.1', '127.0.0.1', '172.16.0.1'],
        correctIndex: 2,
        meme: '🔄 127.0.0.1: Home. There\'s no place like 127.0.0.1.',
      ),
      Question(
        question: 'What is NAT used for in networking?',
        options: [
          'Encrypting all outbound traffic',
          'Translating private IP addresses to a public IP',
          'Assigning MAC addresses',
          'Monitoring network performance',
        ],
        correctIndex: 1,
        meme: '🎭 NAT: Making many devices look like one to the outside world. Master of disguise.',
      ),
      Question(
        question: 'Which port does SSH use by default?',
        options: ['21', '22', '23', '25'],
        correctIndex: 1,
        meme: '🚪 Port 22: The secret hacker-repelling door. Change it on production servers.',
      ),
      Question(
        question: 'What is a packet in networking?',
        options: [
          'A physical cable connector',
          'A unit of data transmitted over a network',
          'A type of wireless protocol',
          'A network security certificate',
        ],
        correctIndex: 1,
        meme: '📦 Packet: Your data, chopped up and shipped like an Amazon order.',
      ),
      Question(
        question: 'What does the OSI model describe?',
        options: [
          'A framework for open-source software',
          'A 7-layer model for how network communication works',
          'An internet security standard',
          'A wireless encryption protocol',
        ],
        correctIndex: 1,
        meme: '🍰 OSI model: 7 layers. Like a cake. Equally hard to explain at parties.',
      ),
      Question(
        question: 'What is latency in networking?',
        options: [
          'The speed of your internet connection',
          'The delay between sending and receiving data',
          'The number of devices on a network',
          'Packet encryption speed',
        ],
        correctIndex: 1,
        meme: '⏱️ Latency: The reason your gaming friends say "stop lagging!" It\'s not you. It\'s the ping.',
      ),
      Question(
        question: 'What does "ping" do?',
        options: [
          'Downloads a file from a remote server',
          'Tests connectivity and measures round-trip time to a host',
          'Scans open ports on a server',
          'Resolves a hostname to an IP',
        ],
        correctIndex: 1,
        meme: '🏓 Ping: "Are you there?" "Yes." "How long did that take?" Networking tennis.',
      ),
      Question(
        question: 'What is bandwidth?',
        options: [
          'The speed of light through a cable',
          'The maximum rate of data transfer across a network',
          'The number of open ports on a device',
          'The strength of a Wi-Fi signal',
        ],
        correctIndex: 1,
        meme: '🛣️ Bandwidth: The width of your internet highway. More lanes = more data.',
      ),
      // ── 10 more Networking questions ──────────────────────────────────────
      Question(
        question: 'What is a proxy server?',
        options: [
          'A server that stores database backups',
          'An intermediary server that forwards requests on behalf of clients',
          'A server dedicated to DNS resolution',
          'A load balancer for web traffic',
        ],
        correctIndex: 1,
        meme: '🎭 Proxy: "I\'ll go ask for you." Useful for privacy, caching, and bypassing geo-blocks.',
      ),
      Question(
        question: 'What does ARP stand for?',
        options: [
          'Automatic Routing Protocol',
          'Address Resolution Protocol',
          'Advanced Relay Process',
          'Application Request Protocol',
        ],
        correctIndex: 1,
        meme: '📣 ARP: "Who has this IP? Tell me their MAC." The local network\'s missing persons bureau.',
      ),
      Question(
        question: 'What is a VLAN?',
        options: [
          'A virtual WAN connection',
          'A logical network segment that groups devices independently of physical location',
          'A type of VPN tunnel',
          'A wireless LAN standard',
        ],
        correctIndex: 1,
        meme: '🏘️ VLAN: Putting devices in separate neighbourhoods without buying new switches.',
      ),
      Question(
        question: 'What port does FTP use by default?',
        options: ['20/21', '22', '25', '110'],
        correctIndex: 0,
        meme: '📁 FTP port 21: Ancient file transfer protocol. Still alive, somehow. Use SFTP instead.',
      ),
      Question(
        question: 'What is a default gateway?',
        options: [
          'The primary DNS server on a network',
          'The router that traffic is sent to when there is no specific route',
          'The first IP address in a subnet',
          'A firewall\'s public IP address',
        ],
        correctIndex: 1,
        meme: '🚪 Default gateway: "I don\'t know where this goes, send it to the router." — your PC.',
      ),
      Question(
        question: 'What does traceroute (or tracert) do?',
        options: [
          'Tests if a host is online',
          'Shows the path packets take to reach a destination',
          'Measures download speed',
          'Lists open ports on a remote host',
        ],
        correctIndex: 1,
        meme: '🗺️ Traceroute: Watching your packet bounce around the world before reaching its destination.',
      ),
      Question(
        question: 'What is the purpose of port 3306?',
        options: [
          'HTTPS traffic',
          'MySQL database connections',
          'SSH remote access',
          'Email sending (SMTP)',
        ],
        correctIndex: 1,
        meme: '🐬 Port 3306: MySQL\'s home. Don\'t expose it to the internet. Seriously.',
      ),
      Question(
        question: 'What is network segmentation?',
        options: [
          'Splitting bandwidth evenly across devices',
          'Dividing a network into smaller zones to limit access and contain breaches',
          'Compressing network packets',
          'Prioritising video traffic on a network',
        ],
        correctIndex: 1,
        meme: '🧱 Network segmentation: Compartmentalising your network so one breach doesn\'t take everything down.',
      ),
      Question(
        question: 'What does "nslookup" do?',
        options: [
          'Scans open ports on a host',
          'Queries DNS to resolve domain names to IP addresses',
          'Shows network interface statistics',
          'Tests HTTP response times',
        ],
        correctIndex: 1,
        meme: '🔍 nslookup: "What IP hides behind that domain?" DNS detective work from the terminal.',
      ),
      Question(
        question: 'What is Quality of Service (QoS) in networking?',
        options: [
          'A metric for measuring ISP uptime',
          'Prioritising certain types of traffic to ensure performance',
          'Encrypting traffic by traffic type',
          'Monitoring network health dashboards',
        ],
        correctIndex: 1,
        meme: '🎬 QoS: Making sure your video call doesn\'t freeze when someone downloads a Linux ISO.',
      ),
    ],
  ),
];


