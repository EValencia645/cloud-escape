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
  final List<Question> questions; // full bank (20)

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
  List<Question> randomSample({int count = 10}) {
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
    ],
  ),
];


