import hashlib, base64, os

# --- SSHA hash function ---
def ssha(password):
    salt = os.urandom(4)
    sha = hashlib.sha1(password.encode() + salt).digest()
    return "{SSHA}" + base64.b64encode(sha + salt).decode()

# --- Input and Output files ---
input_file = "radcheck.txt"   # your text file
output_file = "users.ldif"    # generated LDIF

with open(input_file, "r") as f:
    lines = f.readlines()

with open(output_file, "w") as f:
    for line in lines:
        line = line.strip()
        # skip table headers / separators
        if not line or line.startswith("+") or line.startswith("| id"):
            continue
        
        parts = [p.strip() for p in line.split("|")[1:-1]]  # split and remove borders
        if len(parts) < 5:
            continue
        
        _id, username, attribute, op, value = parts
        
        # only process Cleartext-Password
        if attribute != "Cleartext-Password":
            continue
        
        hashed_pw = ssha(value)
        dn = f"uid={username},ou=Users,dc=insti,dc=srv"
        
        ldif = f"""dn: {dn}
objectClass: inetOrgPerson
objectClass: organizationalPerson
objectClass: person
objectClass: top
uid: {username}
cn: {username}
sn: {username}
mail: {username}
userPassword: {hashed_pw}

"""
        f.write(ldif)

print(f"✅ LDIF file written to {output_file}")
