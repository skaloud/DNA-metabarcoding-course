# Lesson 2: Openstacks - Creating the instance

In this lesson, we will learn how to create and access a virtual machine instance on OpenStack.

## Current Availability
Virtual computers are currently available in Brno or Ostrava (G2).

- **Brno**: [OpenStack Brno](https://brno.openstack.cloud.e-infra.cz/)

### Documentation:
- [OpenStack Compute Documentation](https://docs.e-infra.cz/compute/openstack/)

## Login to OpenStack

1. Go to [Brno OpenStack](https://brno.openstack.cloud.e-infra.cz/)
2. Click on "Login to Horizon Dashboard"
3. Select "e-INFRA CZ federation" for login
4. Confirm "Remember", click "YES", and continue

## Creating the First Instance (Virtual Machine)

Follow the steps provided in the [Getting Started Guide](https://docs.e-infra.cz/compute/openstack/getting-started/creating-first-infrastructure/).

### Step-by-Step Instructions:

### 1. Create a Unique Key for Remote Access
1. Navigate to `Compute` -> `Key Pairs`
2. Click on `Create Key Pair` (e.g., name it `mrkev`, choose `SSH key`)
3. The file `mrkev.pem` is created. **Save the file!**

### 2. Update Security Group
1. Navigate to `Network` -> `Security Groups`
2. Click on `Manage Rules` under the **ssh** name
3. Add the following rules:
   - Rule: `SSH`, do not modify other fields
   - Rule: `all ICMP`, do not modify other fields

### 3. Create a Virtual Machine Instance
1. Navigate to `Compute` -> `Instances`
2. Click on `Launch Instance`
3. Fill in the following details:
   - Instance Name: e.g., `brambora`
   - Count: `1`
4. Click `Next`
5. Select Boot Source:
   - Image: `1000GB`
   - Delete Volume on Instance Delete: `YES`
   - Choose machine (any Ubuntu)
6. Click `Next`
7. Select Flavor:
   - Flavor: `e1.2core-30ram (30GB)`
8. Click `Next`
9. Select Networks:
   - Network: `internal-ipv4-general-private`
10. Click `Launch Instance`

### 4. Associate Floating IP
1. Navigate to `Network` -> `Floating IPs`
2. Click on `Allocate IP to project`
   - Pool: `external`
3. Click `Allocate IP`
4. Navigate to `Compute` -> `Instances`
5. Click on `Associate Floating IP`
6. Manage Floating IP Associations:
   - Select IP address
   - Port is pre-selected
7. Click `Associate`

## Accessing the Virtual Machine

You can access the virtual machine using tools like WinSCP, MobaXterm, etc., using the IP address and the saved key.

Enjoy setting up your virtual machine and exploring the capabilities of OpenStack!

---

[Previous Lesson](../lesson1/lesson1.md) | [Next Lesson](../lesson3/lesson3.md)
