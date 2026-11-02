class Question {
  final String question;
  final List<String> options;
  final int correctIndex;
  final String meme;

  const Question({
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
  final List<Question> questions;

  const Category({
    required this.id,
    required this.emoji,
    required this.title,
    required this.roomName,
    required this.questions,
  });
}

final List<Category> allCategories = [
  // ─────────────────────────────────────────
  //  ☁️  AWS  (10 questions)
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
    ],
  ),

  // ─────────────────────────────────────────
  //  🔐  Security  (10 questions)
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
        options: [
          'password123',
          'qwerty',
          'Tr0ub4dor&3!xK',
          'myname2024',
        ],
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
    ],
  ),

  // ─────────────────────────────────────────
  //  🐧  Linux  (10 questions)
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
    ],
  ),

  // ─────────────────────────────────────────
  //  🌐  Networking  (10 questions)
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
    ],
  ),
];
