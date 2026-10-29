/**
 * @see https://www.prisma.io/docs/guides/migrate/seed-database
 */
import type { Prisma } from '@prisma/client';
import { PrismaClient, Role } from '@prisma/client';
import { genSalt, hash } from 'bcryptjs';

const prisma = new PrismaClient({
  // 'info' | 'query' | 'warn' | 'error'
  log: ['query'],
});

async function seed() {
  await prisma.$connect();
  console.log('Seeding default data...');
  await Promise.all([createDefaultUser(), createDefaultProject()]);
  await prisma.$disconnect();
}

seed()
  .catch((e) => console.error('e', e))
  .finally(async () => await prisma.$disconnect());

async function createDefaultUser() {
  let userList: Prisma.UserGetPayload<undefined>[] = [];
  try {
    userList = await prisma.user.findMany();
    console.log(userList);
  } catch (error) {
    // Expected to see that "user" table does not exist
    console.log(error.message);
  }

  const defaultApiKey =
    '{{ include "visual-regression-tracker.jsString" .Values.vrtConfig.defaults.apiKey }}';
  const defaultEmail =
    '{{ include "visual-regression-tracker.jsString" .Values.vrtConfig.defaults.email }}';
  const defaultPassword =
    '{{ include "visual-regression-tracker.jsString" .Values.vrtConfig.defaults.pass }}';
  const salt = await genSalt(10);

  await prisma.user
    .upsert({
      where: {
        email: defaultEmail,
      },
      update: {
        role: Role.admin,
      },
      create: {
        email: defaultEmail,
        firstName: 'fname',
        lastName: 'lname',
        role: Role.admin,
        apiKey: defaultApiKey,
        password: await hash(defaultPassword, salt),
      },
    })
    .then((user) => {
      console.log('###########################');
      console.log('####### DEFAULT USER ######');
      console.log('###########################');
      console.log('');
      console.log(
        `The user with the email "${defaultEmail}" and password "${defaultPassword}" was created (if not changed before)`,
      );
      console.log(`The Api key is: ${user.apiKey}`);
    });
}

async function createDefaultProject() {
  let projectList: Prisma.ProjectGetPayload<undefined>[] = [];
  try {
    projectList = await prisma.project.findMany();
    console.log(projectList);
  } catch (error) {
    // Expected to see that "project" table does not exist
    console.log(error.message);
  }

  const defaultProject =
    '{{ include "visual-regression-tracker.jsString" .Values.vrtConfig.defaults.project }}';

  if (projectList.length === 0) {
    await prisma.project
      .create({
        data: {
          name: defaultProject,
        },
      })
      .then((project) => {
        console.log('##############################');
        console.log('## CREATING DEFAULT PROJECT ##');
        console.log('##############################');
        console.log('');
        console.log(`Project key: ${project.id}`);
        console.log(`Project name ${project.name}`);
        console.log(`Project name ${project.mainBranchName}`);
      });
  }
}
