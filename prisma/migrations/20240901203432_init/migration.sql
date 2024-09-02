-- CreateTable
CREATE TABLE "Election" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "processNumber" TEXT NOT NULL,
    "date" DATETIME NOT NULL,
    "round" INTEGER NOT NULL,
    "phase" TEXT NOT NULL,
    "type" TEXT NOT NULL
);

-- CreateTable
CREATE TABLE "FederativeUnit" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "abbreviation" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "electionId" TEXT,
    CONSTRAINT "FederativeUnit_electionId_fkey" FOREIGN KEY ("electionId") REFERENCES "Election" ("id") ON DELETE SET NULL ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "Municipality" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "municipalityCode" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "federativeUnitId" TEXT NOT NULL,
    "electionId" TEXT,
    CONSTRAINT "Municipality_federativeUnitId_fkey" FOREIGN KEY ("federativeUnitId") REFERENCES "FederativeUnit" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "Municipality_electionId_fkey" FOREIGN KEY ("electionId") REFERENCES "Election" ("id") ON DELETE SET NULL ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "ElectoralZone" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "zoneCode" TEXT NOT NULL,
    "municipalityId" TEXT NOT NULL,
    CONSTRAINT "ElectoralZone_municipalityId_fkey" FOREIGN KEY ("municipalityId") REFERENCES "Municipality" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "ElectoralSection" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "sectionCode" TEXT NOT NULL,
    "electoralZoneId" TEXT NOT NULL,
    "aggregatedSections" TEXT,
    CONSTRAINT "ElectoralSection_electoralZoneId_fkey" FOREIGN KEY ("electoralZoneId") REFERENCES "ElectoralZone" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "ElectronicBallot" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "serialNumber" TEXT NOT NULL,
    "loadCode" TEXT NOT NULL,
    "softwareVersion" TEXT NOT NULL,
    "sectionId" TEXT NOT NULL,
    CONSTRAINT "ElectronicBallot_sectionId_fkey" FOREIGN KEY ("sectionId") REFERENCES "ElectoralSection" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "VotingLocation" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "locationCode" TEXT NOT NULL,
    "sectionId" TEXT NOT NULL,
    CONSTRAINT "VotingLocation_sectionId_fkey" FOREIGN KEY ("sectionId") REFERENCES "ElectoralSection" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "Voting" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "positionId" TEXT NOT NULL,
    "partyId" TEXT,
    "candidateNumber" TEXT NOT NULL,
    "voteCount" INTEGER NOT NULL,
    "legendVotes" INTEGER,
    "totalVotes" INTEGER NOT NULL,
    CONSTRAINT "Voting_positionId_fkey" FOREIGN KEY ("positionId") REFERENCES "Position" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "Voting_partyId_fkey" FOREIGN KEY ("partyId") REFERENCES "Party" ("id") ON DELETE SET NULL ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "Position" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "positionCode" TEXT NOT NULL,
    "type" INTEGER NOT NULL,
    "dataVersion" TEXT NOT NULL
);

-- CreateTable
CREATE TABLE "Party" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "partyCode" TEXT NOT NULL,
    "name" TEXT NOT NULL
);

-- CreateTable
CREATE TABLE "Summary" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "positionId" TEXT NOT NULL,
    "eligibleVoters" INTEGER NOT NULL,
    "nominalVotes" INTEGER NOT NULL,
    "blankVotes" INTEGER NOT NULL,
    "nullVotes" INTEGER NOT NULL,
    "totalVotes" INTEGER NOT NULL,
    CONSTRAINT "Summary_positionId_fkey" FOREIGN KEY ("positionId") REFERENCES "Position" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "Security" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "contentHash" TEXT NOT NULL,
    "digitalSignature" TEXT NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "FederativeUnit_abbreviation_key" ON "FederativeUnit"("abbreviation");

-- CreateIndex
CREATE UNIQUE INDEX "Party_partyCode_key" ON "Party"("partyCode");
